'use strict'

Args    = require 'args-js'
process = require 'child_process'

module.exports = class Terminal

  @exec: ->
    args = Args([
      {command : Args.STRING   | Args.Required                              }
      {options : Args.OBJECT   | Args.Optional, _default: {encoding: 'utf8'}}
      {cb      : Args.FUNCTION | Args.Optional, _default: undefined         }
    ], arguments)

    return process.execSync args.command, args.options unless args.cb
    process.exec args.command, args.options, args.cb

  @spawn: ->
    args = Args([
      {command : Args.STRING   | Args.Required                              }
      {options : Args.OBJECT   | Args.Optional, _default: {encoding: 'utf8'}}
      {cb      : Args.FUNCTION | Args.Optional, _default: undefined         }
    ], arguments)

    args.command = args.command.split ' '
    return process.spawnSync args.command.shift(), args.command, args.options unless args.cb
    args.cb process.spawn args.command.shift(), args.command, args.options

  @is: (command, expected) =>
    command = @exec command
    return new RegExp(expected).test command if typeof expected is 'object'
    command is expected
