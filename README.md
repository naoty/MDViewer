# MDViewer

## How to run

1. Rename `MDViewer/MDViewer-Info.plist.sample` to `MDViewer/MDViewer-Info.plist`.
2. substitute `APPID` with your app's key on the plist.

```
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>db-APPID</string>
        </array>
    </dict>
</array>
```

3. Create `MDViewer/Secrets.plist` which includes your app's key and secret.

```
<dict>
    <key>App Key</key>
    <string>your app's key</string>
    <key>App Secret</key>
    <string>your app's secret</string>
</dict>
```
