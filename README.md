# oh-my-terminal

[![Build Status](http://img.shields.io/travis/Kikobeats/oh-my-terminal/master.svg?style=flat-square)](https://travis-ci.org/Kikobeats/oh-my-terminal)
[![Dependency status](http://img.shields.io/david/Kikobeats/oh-my-terminal.svg?style=flat-square)](https://david-dm.org/Kikobeats/oh-my-terminal)
[![Dev Dependencies Status](http://img.shields.io/david/dev/Kikobeats/oh-my-terminal.svg?style=flat-square)](https://david-dm.org/Kikobeats/oh-my-terminal#info=devDependencies)
[![NPM Status](http://img.shields.io/npm/dm/oh-my-terminal.svg?style=flat-square)](https://www.npmjs.org/package/oh-my-terminal)
[![Gittip](http://img.shields.io/gittip/Kikobeats.svg?style=flat-square)](https://www.gittip.com/Kikobeats/)

> Simple terminal interface for NodeJS

A simple wrapper that provides a uniform interface for interact with `exec` and `spawn` function of the [child_process](https://nodejs.org/api/child_process.html) module (synchronously and asynchronously).

## Install

```bash
npm install oh-my-terminal
```
## Usage

First load the library:

```js
var terminal = require('oh-my-terminal');
```

If you need just run a command, just call it:

```js
var term = terminal.exec('echo hello world');

console.log(term);
// => 'hello world'
```

Like `exec` or `spawn`, you can provide a custom options for the command:

```js
var options = {
  timeout: 1000
};
var term = terminal.exec('echo hello world', options);

console.log(term);
// => 'hello world'
```

If you need to use asynchronously version, simply provide the callback function for use it:

```js
terminal.exec('echo hello world', function(err, stdout, stderr) {
  console.log(stdout);
  // => 'hello world'  
});
```

If you need to run one command, maybe you need to run more than one. Just instead of `string` pass an `array` of command (with or without callback for user synchronously or asynchronously behavior):

```js
terminal.exec(['echo hello', 'echo world'], function(err, commands) {
  console.log(commands[0].stdout + ' ' + commands[1].stdout);
  // => 'hello world'  
});
```

## API

### .exec(&lt;command[s]&gt;, [options], [callback])

Invoke child_process.exec (or execSync) function. You can provide just one command or an array of command to be executed.

If you provide a callback then the function will executed asynchronously.

### .spawn(&lt;command[s]&gt;, [options], [callback])

Invoke child_process.spawn (or spawn) function. You can provide just one command or an array of command to be executed.

If you provide a callback then the function will executed asynchronously.


## What is the difference?

You can note that the methods are very similar, but have appreciate difference between us that basically depende of what you need in the oputput.

Also remmeber that when a method is synchronous, it means that WILL block the event loop, pausing execution of your code until the spawned process exits.

### exec

Because the output is based in the size of a Buffer, you must to use for command that output few data.

#### synchronously version

The output is just `stdout` if the code error of the command is  0. In other case, throw a `Error` and the result is the same that **spawnSync**.

#### asynchronously version

Returns the buffer version of the output (`error`, `stdout` and `stderr`).

### spawn

When your commands output some data or you need some information about the process (like the `PID`).

#### synchronously version

The result will not return until the child process has fully closed by the OS, so whenever possible use the asynchronously where is possible handle the data of the stream more soon.

#### asynchronously version

It's a stream that starts sending back data from the child process in a stream as soon as the child process starts executing.

## License

MIT © [Kiko Beats](http://www.kikobeats.com)


