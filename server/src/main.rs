use axum::{
    extract::{
        ws::{Message, WebSocket, WebSocketUpgrade},
        State,
    },
    response::IntoResponse,
    routing::get,
    Router,
};
use futures_util::{stream::StreamExt, SinkExt};
use serde::{Deserialize, Serialize};
use std::{
    collections::HashMap,
    sync::Arc,
};
use tokio::sync::{mpsc, RwLock};

#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "type")]
enum ClientMessage {
    Identify { public_key: String },
    Relay { recipient_key: String, payload: String },
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "type")]
enum ServerMessage {
    Error { message: String },
    Relayed { sender_key: String, payload: String },
}

type ClientMap = Arc<RwLock<HashMap<String, mpsc::UnboundedSender<Message>>>>;

#[tokio::main]
async fn main() {
    let clients: ClientMap = Arc::new(RwLock::new(HashMap::new()));

    let app = Router::new()
        .route("/ws", get(ws_handler))
        .with_state(clients);

    let addr = "0.0.0.0:8080";
    println!("MeshTalk Relay Server listening on ws://{}", addr);
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn ws_handler(
    ws: WebSocketUpgrade,
    State(clients): State<ClientMap>,
) -> impl IntoResponse {
    ws.on_upgrade(|socket| handle_socket(socket, clients))
}

async fn handle_socket(socket: WebSocket, clients: ClientMap) {
    let (mut sender, mut receiver) = socket.split();
    let (tx, mut rx) = mpsc::unbounded_channel();
    
    let mut current_pub_key: Option<String> = None;

    // Forward messages from our mpsc channel to the actual websocket
    let forward_task = tokio::spawn(async move {
        while let Some(msg) = rx.recv().await {
            if sender.send(msg).await.is_err() {
                break;
            }
        }
    });

    while let Some(Ok(msg)) = receiver.next().await {
        if let Message::Text(text) = msg {
            if let Ok(client_msg) = serde_json::from_str::<ClientMessage>(&text) {
                match client_msg {
                    ClientMessage::Identify { public_key } => {
                        let mut map = clients.write().await;
                        map.insert(public_key.clone(), tx.clone());
                        current_pub_key = Some(public_key.clone());
                        println!("Client identified: {}", public_key);
                    }
                    ClientMessage::Relay { recipient_key, payload } => {
                        if let Some(ref my_key) = current_pub_key {
                            let map = clients.read().await;
                            if let Some(recipient_tx) = map.get(&recipient_key) {
                                let relay_msg = ServerMessage::Relayed {
                                    sender_key: my_key.clone(),
                                    payload,
                                };
                                let _ = recipient_tx.send(Message::Text(
                                    serde_json::to_string(&relay_msg).unwrap().into()
                                ));
                                println!("Relayed message from {} to {}", my_key, recipient_key);
                            } else {
                                // Recipient offline
                                let err_msg = ServerMessage::Error {
                                    message: "Recipient is currently offline".to_string(),
                                };
                                let _ = tx.send(Message::Text(
                                    serde_json::to_string(&err_msg).unwrap().into()
                                ));
                            }
                        }
                    }
                }
            }
        }
    }

    // Cleanup on disconnect
    if let Some(key) = current_pub_key {
        println!("Client disconnected: {}", key);
        clients.write().await.remove(&key);
    }
    
    forward_task.abort();
}
