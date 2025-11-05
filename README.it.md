# Clipboard Manager per macOS

Un clipboard manager leggero e moderno per macOS che vive nella barra dei menu.

## Caratteristiche

- 📋 **Cronologia completa**: Memorizza fino a 100 elementi copiati
- 🔍 **Ricerca veloce**: Trova rapidamente ciò che hai copiato in passato
- 💾 **Persistenza**: La cronologia viene salvata automaticamente
- 🎨 **Interfaccia moderna**: UI pulita con SwiftUI
- ⚡ **Leggero**: Vive nella barra dei menu senza occupare spazio nel Dock
- 📌 **Pin elementi**: Fissa gli elementi importanti per mantenerli sempre in cima
- 🗑️ **Gestione facile**: Elimina singoli elementi o cancella tutta la cronologia
- ⌨️ **Hotkey globale**: Apri la cronologia con **Cmd+Shift+V** da qualsiasi app
- 🚀 **Avvio automatico**: Opzione per avviare l'app al login
- 🌍 **Multilingua**: Supporto completo per italiano e inglese

## Requisiti

- macOS 13.0 (Ventura) o superiore
- Swift 6.0

## Installazione

### Metodo 1: Crea l'app bundle e installa

Usa lo script di build incluso per creare un'app macOS completa:

```bash
./build_app.sh
```

Questo creerà `ClipboardManager.app` nella directory corrente. Per installarlo:

```bash
cp -R ClipboardManager.app /Applications/
```

Poi avvia l'app da Spotlight o dal Finder.

### Metodo 2: Compilazione ed esecuzione diretta

Per sviluppo o test rapidi:

```bash
swift build -c release
.build/release/ClipboardManager
```

Oppure esegui direttamente:

```bash
swift run
```

## Utilizzo

1. Avvia l'applicazione - vedrai un'icona nella barra dei menu
2. **Premi Cmd+Shift+V** da qualsiasi app per aprire la cronologia (oppure clicca sull'icona)
3. Al primo avvio, concedi i permessi di Accessibility quando richiesto (necessari per l'hotkey globale)
4. Clicca su un elemento per copiarlo nella clipboard
5. Usa la barra di ricerca per filtrare gli elementi
6. Passa il mouse su un elemento per vedere le opzioni (pin, copia, elimina)

### Funzionalità

- **Hotkey globale**: Premi **Cmd+Shift+V** da qualsiasi applicazione per aprire il menu
- **Cronologia automatica**: Ogni testo copiato viene salvato automaticamente
- **Pin elementi**: Fissa gli elementi importanti - non verranno eliminati quando cancelli la cronologia
- **Copia rapida**: Clicca su un elemento per copiarlo e chiudere il popover
- **Ricerca**: Filtra gli elementi digitando nella barra di ricerca
- **Elimina**: Passa il mouse e clicca sull'icona cestino per eliminare un elemento
- **Cancella tutto**: Clicca sull'icona cestino nell'header per svuotare la cronologia (preserva i pin)
- **Avvio al login**: Attiva lo switch nell'header per avviare l'app automaticamente al login
- **Esci**: Clicca sull'icona X nell'header per chiudere l'applicazione

## Struttura del progetto

```
ClipboardManager/
├── Sources/
│   └── ClipboardManager/
│       ├── ClipboardManager.swift      # Entry point
│       ├── ClipboardItem.swift         # Modello dati
│       ├── ClipboardMonitor.swift      # Monitoring clipboard
│       ├── StatusBarController.swift   # Menu bar controller
│       ├── HotKeyManager.swift         # Global hotkey handler
│       ├── LaunchAtLoginManager.swift  # Launch at login handler
│       ├── ContentView.swift           # SwiftUI interface
│       ├── Localizable.swift           # Localization helper
│       └── Resources/                  # Localization files
│           ├── it.lproj/
│           └── en.lproj/
├── Package.swift
├── build_app.sh                        # Build script
├── AppIcon.icns                        # App icon
└── README.md
```

## Note tecniche

- Utilizza `NSPasteboard` per monitorare i cambiamenti della clipboard
- La cronologia viene salvata in `UserDefaults` per la persistenza
- L'interfaccia è costruita con SwiftUI e AppKit
- L'app usa `.accessory` activation policy per non apparire nel Dock
- Il monitoring della clipboard avviene ogni 0.5 secondi
- Hotkey globale implementato con Carbon Event Manager
- Launch at login implementato con `SMAppService` (macOS 13+)
- Supporto per localizzazione italiano/inglese automatico basato sulle impostazioni di sistema
- **Richiede permessi di Accessibility** per l'hotkey globale (il sistema chiederà automaticamente)

## Licenza

MIT
