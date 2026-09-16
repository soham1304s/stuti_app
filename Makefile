.PHONY: all run-server run-client clean format

# Default target
all:
	@echo "Usage:"
	@echo "  make run-server    - Run the Rust P2P WebSocket relay server"
	@echo "  make run-client    - Run the Flutter mobile client"
	@echo "  make clean         - Clean both client and server builds"
	@echo "  make format        - Format both client and server code"

# Server commands
run-server:
	@echo "Starting Rust P2P Server..."
	cd server && cargo run

# Client commands
run-client:
	@echo "Starting Flutter Client..."
	cd client && flutter run

# Clean project
clean:
	@echo "Cleaning Server..."
	cd server && cargo clean
	@echo "Cleaning Client..."
	cd client && flutter clean

# Format code
format:
	@echo "Formatting Server..."
	cd server && cargo fmt
	@echo "Formatting Client..."
	cd client && dart format .
