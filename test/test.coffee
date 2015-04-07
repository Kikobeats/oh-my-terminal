terminal = require '..'
should   = require 'should'

describe 'Oh My Terminal ::', ->

  describe 'exec', ->

    it 'exec a command', ->
      start = new Date().getTime()
      term = terminal.exec 'echo hello world'
      end = new Date().getTime();
      console.log "Execution time: #{end - start} ms"
      (term is 'hello world\n').should.be.equal true

    it 'exec an array of commands', ->
      start = new Date().getTime()
      term = terminal.exec ['echo hello world', 'echo hello world']
      end = new Date().getTime();
      console.log "Execution time: #{end - start} ms"
      (term[0] is 'hello world\n').should.be.equal true
      (term[1] is 'hello world\n').should.be.equal true

    it 'exec just a command async', (done) ->
      start = new Date().getTime()
      terminal.exec 'echo hello world', (err, stdout, stderr) ->
        end = new Date().getTime();
        console.log "Execution time: #{end - start} ms"
        (err is null).should.be.equal true
        (stdout is 'hello world\n').should.be.equal true
        done()

    it 'exec an array of commands async', (done) ->
      start = new Date().getTime()
      terminal.exec ['echo hello world', 'echo hello world'], (err, commands) ->
        end = new Date().getTime();
        console.log "Execution time: #{end - start} ms"
        (err is null).should.be.equal true
        (commands[0].stdout is 'hello world\n').should.be.equal true
        (commands[1].stdout is 'hello world\n').should.be.equal true
        done()

  describe 'spawn', ->

    it 'spawn a command', ->
      start = new Date().getTime()
      child = terminal.spawn 'echo hello world'
      end = new Date().getTime();
      console.log "Execution time: #{end - start} ms"
      child.output[1].should.be.equal 'hello world\n'

    it 'spawn an array of command', ->
      start = new Date().getTime()
      child = terminal.spawn ['echo hello world', 'echo hello world']
      end = new Date().getTime();
      console.log "Execution time: #{end - start} ms"
      child[0].output[1].should.be.equal 'hello world\n'
      child[1].output[1].should.be.equal 'hello world\n'

    it 'spawn a command async', (done) ->
      start = new Date().getTime()
      terminal.spawn 'echo hello world', (child) ->
        end = new Date().getTime();
        console.log "Execution time: #{end - start} ms"
        # child.stdout.on 'data', (data) ->
        #   console.log 'stdout: ' + data
        #   return
        # child.stderr.on 'data', (data) ->
        #   console.log 'stderr: ' + data
        #   return
        # child.on 'close', (code) ->
        #   console.log 'child process exited with code ' + code
        #   return
        (typeof child is 'object').should.be.equal true
        done()

    it 'spawn an array of command async', (done) ->
      start = new Date().getTime()
      terminal.spawn ['echo hello world', 'echo hello world'], (childs) ->
        end = new Date().getTime();
        console.log "Execution time: #{end - start} ms"
        (typeof childs[0] is 'object').should.be.equal true
        (typeof childs[1] is 'object').should.be.equal true
        done()
