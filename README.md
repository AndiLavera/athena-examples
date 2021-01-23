# Athena WS Chat

## Usage

- clone
- install shards
- `crystal run src/start.cr`
- Open `localhost:3000` in 2 tabs recommended side-by-side
- Enter a message in 1 and watch the other tab

> Note: Chat does not persist. Refreshing will remove the text nodes.

## About

> Note: Firefox is finicky with websockets especially when you are refreshing. It can take upto 30 seconds for the connection to open. Watch the network tab for a 101 status code with file path `cable`.

### Crystal

- Uses a forked version of athena found [here](https://github.com/andrewc910/athena/tree/ws)

  - Added the `upgrade_handler` property in `ART::Response`

- All `cable.cr` code is in `src/websockets` but there is also a listener.

- Connections & messages are logged so feel free to look at your terminal.

### Javascript

- Code for frontend is in `index.js`

- You will see an `actioncable.js` file. That's a npm package. We have no bundler so i copied & pasted the code. Ideally you would just do `require('actioncable')` in your `index.js` file.

- Connections & messages are logged so feel free to look at your console.
