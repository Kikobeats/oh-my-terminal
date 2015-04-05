terminal = require '..'
should   = require 'should'

describe 'Oh My Terminal ::', ->

  describe 'exec', ->

    it 'exec a command', ->
      term = terminal.exec 'echo hello world'
      (term is 'hello world\n').should.be.equal true

    it 'exec a command async', (done) ->
      terminal.exec 'echo hello world', (err, stdout, stderr) ->
        (err is null).should.be.equal true
        (stdout is 'hello world\n').should.be.equal true
        done()

  describe 'spawn', ->

    it 'spawn a command', ->
      child = terminal.spawn 'echo hello world'
      child.output[1].should.be.equal 'hello world\n'

    it 'spawn a command async', (done) ->
      terminal.spawn 'echo hello world', (child) ->
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

  describe 'is', ->

    it 'compare the result of a exec command', ->
      (terminal.is 'echo hello world', 'hello world\n').should.be.equal true

    xit 'compare the result of a exec command with regex', ->
      (terminal.is 'node -v', /v0.1[0-9]/g).should.be.equal true
