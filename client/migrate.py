import os
import re

directories = ['lib/features/']

def replace_provider(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    if 'package:provider/provider.dart' not in content:
        return

    # Replace import
    content = content.replace("import 'package:provider/provider.dart';", "import 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:meshtalk_client/app/providers.dart';")

    # Replace StatefulWidget with ConsumerStatefulWidget
    content = re.sub(r'class (\w+) extends StatefulWidget', r'class \1 extends ConsumerStatefulWidget', content)
    content = re.sub(r'class (_\w+) extends State<(\w+)>', r'class \1 extends ConsumerState<\2>', content)
    
    # Replace StatelessWidget with ConsumerWidget
    content = re.sub(r'class (\w+) extends StatelessWidget', r'class \1 extends ConsumerWidget', content)
    
    # Replace Widget build(BuildContext context) with Widget build(BuildContext context, WidgetRef ref)
    # ONLY for StatelessWidget which are now ConsumerWidget
    # We do a basic check: if it's a StatelessWidget, we need to add WidgetRef ref
    # For ConsumerState, build already has (BuildContext context), but we can just use ref directly since it's a property.
    # So we only need to change it for ConsumerWidget.
    
    # Let's fix build method signature for ConsumerWidget (not State)
    if 'ConsumerWidget' in content:
        content = re.sub(r'Widget build\(BuildContext context\)', r'Widget build(BuildContext context, WidgetRef ref)', content)

    # Replace context.watch<T>() with ref.watch(tProvider)
    # This requires some manual mapping
    replacements = {
        'context.watch<StorageService>()': 'ref.watch(storageServiceProvider)',
        'context.read<StorageService>()': 'ref.read(storageServiceProvider)',
        'context.watch<ConnectivityService>()': 'ref.watch(connectivityServiceProvider)',
        'context.read<ConnectivityService>()': 'ref.read(connectivityServiceProvider)',
        'context.watch<NearbyDeviceService>()': 'ref.watch(nearbyDeviceServiceProvider)',
        'context.read<NearbyDeviceService>()': 'ref.read(nearbyDeviceServiceProvider)',
        'context.watch<TransportManager>()': 'ref.watch(transportManagerProvider)',
        'context.read<TransportManager>()': 'ref.read(transportManagerProvider)',
        'context.watch<StoryServerService>()': 'ref.watch(storyServerServiceProvider)',
        'context.read<StoryServerService>()': 'ref.read(storyServerServiceProvider)',
    }
    
    for old, new in replacements.items():
        content = content.replace(old, new)
        
    # Replace Consumer<StoryServerService> with Consumer (from riverpod)
    # Wait, Riverpod's Consumer builder takes (context, ref, child). The old one took (context, service, child).
    # We'll just replace Consumer<T>(builder: (context, val, child)) with a custom build, but it's easier to just do it manually for that one file.
    
    with open(filepath, 'w') as f:
        f.write(content)
    print(f"Updated {filepath}")

for root, _, files in os.walk('lib/features/'):
    for file in files:
        if file.endswith('.dart'):
            replace_provider(os.path.join(root, file))
