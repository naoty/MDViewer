# MDViewer

Markdown viewer for iPad

## How to run

- Rename `MDViewer/MDViewer-Info.plist.sample` to `MDViewer/MDViewer-Info.plist`.
- Register a Dropbox application for your account and get app's key and secret.
- substitute `APP_KEY` with your app's key on the plist.

```
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>db-APP_KEY</string>
        </array>
    </dict>
</array>
```

- Create `MDViewer/Secrets.plist` which includes your app's key and secret.

```
<dict>
    <key>App Key</key>
    <string>your app's key</string>
    <key>App Secret</key>
    <string>your app's secret</string>
</dict>
```
