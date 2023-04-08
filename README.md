# Code-server Credential Workaround

This repository provides a workaround for Linux users experiencing issues with the Secret Service API/libsecret, which code-server's keytar module relies on for credential management. The workaround involves creating a drop-in replacement for keytar.

The implementation of the replacement keytar module is taken from the work of [stevenlafl](https://github.com/stevenlafl)'s [fork](https://github.com/stevenlafl/node-keytar) of `node-keytar` moudle.

**Note:** Please be aware that modifying code-server's keytar module may have potential risks and limitations, and should be used at your own risk.

## Usage

Clone the repo or download the script by running the following command in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/YanivBah/code-server-credential-workaround/main/local_codeserver_credentials.sh -o local_codeserver_credentials.sh
```

Make the script executable by running the following command:

```bash
chmod +x local_codeserver_credentials.sh
```

Run the script with sudo by running the following command:

```bash
sudo ./local_codeserver_credentials.sh
```
