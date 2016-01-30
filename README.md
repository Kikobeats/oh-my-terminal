# oh-my-terminal

![Last version](https://img.shields.io/github/tag/Kikobeats/oh-my-terminal.svg?style=flat-square)
[![Build Status](http://img.shields.io/travis/Kikobeats/oh-my-terminal/master.svg?style=flat-square)](https://travis-ci.org/Kikobeats/oh-my-terminal)
[![Dependency status](http://img.shields.io/david/Kikobeats/oh-my-terminal.svg?style=flat-square)](https://david-dm.org/Kikobeats/oh-my-terminal)
[![Dev Dependencies Status](http://img.shields.io/david/dev/Kikobeats/oh-my-terminal.svg?style=flat-square)](https://david-dm.org/Kikobeats/oh-my-terminal#info=devDependencies)
[![NPM Status](http://img.shields.io/npm/dm/oh-my-terminal.svg?style=flat-square)](https://www.npmjs.org/package/oh-my-terminal)
[![Donate](https://img.shields.io/badge/donate-paypal-blue.svg?style=flat-square)](https://paypal.me/kikobeats)

> Simple and unmistakable terminal interface for NodeJS.

## Why

- Based in NodeJS `exec` and `spawn` native interface.
- Automatically provide a polyfill for non native compatible node versions (for example, `execSync` under `0.10`).
- Uniform methods for synchronously and asynchronously, just decide providing or not a callback.
- Little improvements, like posibility for run a set of commands in the same command or more information about the process status in `sync` versions.

## Install

```bash
npm install oh-my-terminal --save
```
## Example

First load the library:

```js
var terminal = require('oh-my-terminal');
```

### Simple Usage

Now, you can run a command using `exec` or `spawn` methods. Exists slight difference between us (as you know from [child_process](https://nodejs.org/api/child_process.html).

Using **exec**:

```js
var term = terminal.exec('echo hello world');

console.log(term);
// => {
//   stdout: 'hello world\n',
//   stderr: '',
//   status: 0
// }
```

Using **spawn**:

```js
var term = terminal.spawn('echo hello world');

console.log(term);
// => {
//   pid: 95109,
//   output: [ null, 'hello world\n', '' ],
//   stdout: 'hello world\n',
//   stderr: '',
//   status: 0,
//   signal: null
// }
```

### Custom Options

Like `exec` or `spawn`, you can provide a custom options for the command:

```js
var options = {
  timeout: 1000
};
var term = terminal.exec('echo hello world', options);

console.log(term.stdout);
// => 'hello world\n'
```

### More than one

If you need to run one command, maybe you need to run more than one. Just instead of `string` pass an `array` of command (with or without callback for user synchronously or asynchronously behavior):

```js
terminal.exec(['echo hello', 'echo world'], function(err, commands) {
  console.log(commands[0].stdout);
  // => 'hello world\n'
  console.log(commands[1].stdout);
  // => 'hello world\n'
});
```

### Async mode

Just providing a standard NodeJS callback you activate the async mode for the command:

```js
terminal.exec('echo hello world', function(err, command) {
  console.log(command.stdout);
  // => 'hello world\n'
});
```

You can run a set of command in async mode as well:

```js
terminal.exec(['echo hello world', 'echo hello world'], function(err, commands) {
  console.log(commands[0].stdout);
  // => 'hello world\n'
  console.log(commands[1].stdout);
  // => 'hello world\n'
});
```

## API

### .exec(&lt;command[s]&gt;, [options], [callback])

Invoke `child_process.exec` (or `execSync` if you don't provide a callback) function. You can provide just one `String` command or an `Array` of command to be executed.

Options are [child_process.exec](https://nodejs.org/api/child_process.html#child_process_child_process_exec_command_options_callback) options. `{ encoding: 'utf8' }` by default.

### .spawn(&lt;command[s]&gt;, [options], [callback])

Invoke `child_process.spawn` (or `spawnSync` if you don't provide a callback) function. You can provide just one `String` command or an `Array` of command to be executed.

Options are [child_process.spawn](https://nodejs.org/api/child_process.html#child_process_child_process_spawn_command_args_options) options. `{ encoding: 'utf8' }` by default.

Note that in this case the response is a [Stream Object](https://nodejs.org/api/child_process.html#child_process_child_process_spawn_command_args_options) that starts sending back data from the child process in a stream as soon as the child process starts executing.

## License

MIT © [Kiko Beats](http://www.kikobeats.com)
