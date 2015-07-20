terminal = require '..'
should   = require 'should'
assert   = require 'assert'

SAMPLE =
  COMMAND: 'echo hello world'
  OUTPUT: 'hello world\n'

describe 'Oh My Terminal ::', ->

  describe 'exec', ->

    it 'exec a command', ->
      start = new Date().getTime()
      term = terminal.exec SAMPLE.COMMAND
      end = new Date().getTime();
      console.log "Execution time: #{end - start} ms"
      (term.stdout is SAMPLE.OUTPUT).should.be.equal true

    it 'exec a command with error', ->
      start = new Date().getTime()
      term = terminal.exec 'LOL'
      end = new Date().getTime();
      console.log "Execution time: #{end - start} ms"
      (term.status isnt 0).should.be.equal true

    it 'exec an array of commands', ->
      start = new Date().getTime()
      term = terminal.exec [SAMPLE.COMMAND, SAMPLE.COMMAND]
      end = new Date().getTime();
      console.log "Execution time: #{end - start} ms"
      (term[0].stdout is SAMPLE.OUTPUT).should.be.equal true
      (term[1].stdout is SAMPLE.OUTPUT).should.be.equal true

    it 'exec just a command async', (done) ->
      start = new Date().getTime()
      terminal.exec SAMPLE.COMMAND, (err, term) ->
        end = new Date().getTime();
        console.log "Execution time: #{end - start} ms"
        (err is null).should.be.equal true
        (term.stdout is SAMPLE.OUTPUT).should.be.equal true
        done()

    it 'exec just a command async with error', (done) ->
      start = new Date().getTime()
      terminal.exec 'LOL', (err, term) ->
        end = new Date().getTime();
        console.log "Execution time: #{end - start} ms"
        (err?).should.be.equal true
        done()

    it 'exec an array of commands async', (done) ->
      start = new Date().getTime()
      terminal.exec [SAMPLE.COMMAND, SAMPLE.COMMAND], (err, commands) ->
        end = new Date().getTime();
        console.log "Execution time: #{end - start} ms"
        (err is null).should.be.equal true
        (commands[0].stdout is SAMPLE.OUTPUT).should.be.equal true
        (commands[1].stdout is SAMPLE.OUTPUT).should.be.equal true
        done()

  describe 'spawn', ->

    it 'spawn a command', ->
      start = new Date().getTime()
      term = terminal.spawn SAMPLE.COMMAND
      end = new Date().getTime();
      console.log "Execution time: #{end - start} ms"
      term.stdout.should.be.equal SAMPLE.OUTPUT

    it 'spawn a command with error', ->
      start = new Date().getTime()
      term = terminal.spawn 'LOL'
      end = new Date().getTime();
      console.log "Execution time: #{end - start} ms"
      (term.status isnt 0).should.be.equal true

    it 'spawn an array of command', ->
      start = new Date().getTime()
      term = terminal.spawn [SAMPLE.COMMAND, SAMPLE.COMMAND]
      end = new Date().getTime();
      console.log "Execution time: #{end - start} ms"
      term[0].output[1].should.be.equal SAMPLE.OUTPUT
      term[1].output[1].should.be.equal SAMPLE.OUTPUT

    it 'spawn a command async', (done) ->
      start = new Date().getTime()
      terminal.spawn SAMPLE.COMMAND, (child) ->
        end = new Date().getTime();

        term =
          stdout: ''
          stderr: ''

        child.stdout.on 'data', (data) -> term.stdout += data
        child.stderr.on 'data', (data) -> term.stderr += data

        child.on 'close', (code) ->
          term.status = code
          console.log "Execution time: #{end - start} ms"
          term.stdout is SAMPLE.OUTPUT
          done()

    xit 'spawn a command async with error', (done) ->

      ## TODO: Repair this :'(
      start = new Date().getTime()

      (->
        terminal.spawn 'LOL', ->
          return
      ).should.throw(Error)

    it 'spawn an array of command async', (done) ->
      start = new Date().getTime()
      terminal.spawn [SAMPLE.COMMAND, SAMPLE.COMMAND], (childs) ->
        end = new Date().getTime();
        console.log "Execution time: #{end - start} ms"
        (typeof childs[0] is 'object').should.be.equal true
        (typeof childs[1] is 'object').should.be.equal true
        done()
