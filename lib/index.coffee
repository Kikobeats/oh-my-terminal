'use strict'

Args             = require 'args-js'
parallel         = require 'run-parallel'
childProcess     = require 'child_process'
spawn            = require('child_process').spawn
# the library uses native use native child_process.execSync if available (from node v0.12+)
execSync         = require 'sync-exec'
# the library on iojs and node >= 0.12 it will just export the built in child_process.spawnSync
spawnSync        = require 'spawn-sync'

exec = (cmd, opts, cb) ->
  childProcess.exec cmd, opts, (err, stdout, stderr) ->
    cb err, { stdout: stdout, stderr: stderr}

module.exports = class Terminal

  @exec: ->
    args = Args([
      [{cmd: Args.STRING   | Args.Required}, {cmd: Args.ARRAY  | Args.Required}]
      {opts: Args.OBJECT   | Args.Optional, _default: {encoding: 'utf8'}}
      {cb  : Args.FUNCTION | Args.Optional, _default: undefined}
    ], arguments)

    isSingleCommand = typeof args.cmd is 'string'

    unless args.cb
      return execSync args.cmd, args.opts if isSingleCommand
      child = []
      child.push @exec cmd for cmd in args.cmd
      return child

    return exec args.cmd, args.opts, args.cb if isSingleCommand

    childFunction = (cmd, next) =>
      @exec cmd, args.opts, next

    child = []
    child.push childFunction.bind childFunction, cmd for cmd in args.cmd
    parallel child, args.cb

  @spawn: ->
    args = Args([
      [{cmd: Args.STRING   | Args.Required}, {cmd: Args.ARRAY  | Args.Required}]
      {opts: Args.OBJECT   | Args.Optional, _default: {encoding: 'utf8'}}
      {cb  : Args.FUNCTION | Args.Optional, _default: undefined         }
    ], arguments)

    isSingleCommand = typeof args.cmd is 'string'

    unless args.cb
      if isSingleCommand
        args.cmd = args.cmd.split ' '
        return spawnSync args.cmd.shift(), args.cmd, args.opts

      child = []
      child.push @spawn cmd for cmd in args.cmd
      return child

    if isSingleCommand
      args.cmd = args.cmd.split ' '
      return args.cb spawn args.cmd.shift(), args.cmd, args.opts

    childFunction = (cmd, next) ->
      cmd = cmd.split ' '
      next null, spawn cmd.shift(), cmd, args.opts

    child = []
    child.push childFunction.bind childFunction, cmd for cmd in args.cmd
    parallel child, (err, results) -> args.cb results
