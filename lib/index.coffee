'use strict'

Args             = require 'args-js'
parallel         = require 'run-parallel'
childProcess     = require 'child_process'
spawn            = require('child_process').spawn
# the library uses native use native child_process.execSync if available (from node v0.12+)
execSync         = require 'sync-exec'
# the library on iojs and node >= 0.12 it will just export the built in child_process.spawnSync
spawnSync        = require 'spawn-sync'

exec = (command, options, cb) ->
  childProcess.exec command, options, (err, stdout, stderr) ->
    cb err, { stdout: stdout, stderr: stderr}

module.exports = class Terminal

  @exec: ->
    args = Args([
      [{command: Args.STRING   | Args.Required}, {command: Args.ARRAY  | Args.Required}]
      {options : Args.OBJECT   | Args.Optional, _default: {encoding: 'utf8'}}
      {cb      : Args.FUNCTION | Args.Optional, _default: undefined}
    ], arguments)

    isSingleCommand = typeof args.command is 'string'

    unless args.cb
      return execSync args.command args.options if isSingleCommand
      child = []
      child.push @exec command for command in args.command
      return child

    return exec args.command, args.options, args.cb if isSingleCommand

    childFunction = (command, next) =>
      @exec command, args.options, next

    child = []
    child.push childFunction.bind childFunction, command for command in args.command
    parallel child, args.cb

  @spawn: ->
    args = Args([
      [{command: Args.STRING | Args.Required}, {command: Args.ARRAY  | Args.Required}]
      {options : Args.OBJECT   | Args.Optional, _default: {encoding: 'utf8'}}
      {cb      : Args.FUNCTION | Args.Optional, _default: undefined         }
    ], arguments)

    isSingleCommand = typeof args.command is 'string'

    unless args.cb
      if isSingleCommand
        args.command = args.command.split ' '
        return spawnSync args.command.shift(), args.command, args.options

      child = []
      child.push @spawn command for command in args.command
      return child

    if isSingleCommand
      args.command = args.command.split ' '
      return args.cb spawn args.command.shift(), args.command, args.options

    childFunction = (command, next) ->
      command = command.split ' '
      next null, spawn command.shift(), command, args.options

    child = []
    child.push childFunction.bind childFunction, command for command in args.command
    parallel child, (err, results) -> args.cb results
