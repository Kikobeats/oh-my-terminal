'use strict'

Args     = require 'args-js'
process  = require 'child_process'
parallel = require 'run-parallel'

module.exports = class Terminal

  @exec: ->
    args = Args([
      [{command: Args.STRING   | Args.Required}, {command: Args.ARRAY  | Args.Required}]
      {options : Args.OBJECT   | Args.Optional, _default: {stdio: 'pipe', encoding: 'utf8'}}
      {cb      : Args.FUNCTION | Args.Optional, _default: undefined}
    ], arguments)

    isSingleCommand = typeof args.command is 'string'

    unless args.cb
      return process.execSync args.command, args.options if isSingleCommand
      child = []
      child.push @exec command for command in args.command
      return child

    return process.exec args.command, args.options, args.cb if isSingleCommand

    childFunction = (command, callback) =>
      @exec command, args.options, (err, stdout, stderr) ->
        callback(err) if err
        callback(null, stdout: stdout, stderr: stderr)

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
        return process.spawnSync args.command.shift(), args.command, args.options

      child = []
      child.push @spawn command for command in args.command
      return child

    if isSingleCommand
      args.command = args.command.split ' '
      return args.cb process.spawn args.command.shift(), args.command, args.options

    childFunction = (command, callback) ->
      command = command.split ' '
      callback(null, process.spawn command.shift(), command, args.options)

    child = []
    child.push childFunction.bind childFunction, command for command in args.command
    parallel child, (err, results) -> args.cb(results)
