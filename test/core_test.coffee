should = require("should")

coreModule = require("../src/core")
core = coreModule.core
cache = coreModule.cache


setupStory = (roomName = 'roomName', amount = 1) ->
  core.addStory roomName, "story#{i}" for i in [1 .. amount]
  core.listStories(roomName)

setupParticipant = (roomName = 'roomName', amount = 1) ->
  core.addParticipant roomName, "participant#{i}" for i in [1 .. amount]
  core.listParticipants(roomName)


describe("core", () ->
  beforeEach ->
    cache.clear()

  describe 'addStory()', ->
    it 'can add first story, #storiesExist', ->
      result = setupStory('roomName', 1)
      result.should.eql({story1: null})

  describe 'listStory()', ->
    it 'returns blank when no stories, #storiesExist', ->
      result = core.listStories('roomName')
      result.should.eql({})

    it 'stories are listed in order of addition', ->
      result = setupStory('roomName', 2)
      result.should.eql({story1: null, story2: null})

  describe 'addParticipant()', ->
    it 'add first participant should be in list, #participantExists', -> # QUESTION: duplicate-01
      result = setupParticipant('roomName', 1)
      result.should.eql({participant1: null})

    it 'add two participant should set 2 value in data', ->
      result = setupParticipant('roomName', 2)
      result.should.eql({participant1: null, participant2: null})

  describe 'listParticipant()', ->
    it 'return blank when no participants, #participantExists' , ->
      result = core.listParticipants('roomName')
      result.should.eql({})

    it 'list participants will return object of participants' , -> # QUESTION: duplicate-01, Is this wrong? (caused by setupStory)
      result = setupParticipant('roomName', 1)
      result.should.eql({participant1: null})

  describe 'removeParticipant()', ->
    it 'should remove specified participant from set', ->
      setupParticipant('roomName', 2)
      core.removeParticipant('roomName', 'participant1')
      result = core.listParticipants('roomName')
      result.should.eql({participant2: null})

    it 'should not remove anything if a participant does not exist, #participantExists', ->
      setupParticipant('roomName', 1)
      core.removeParticipant('roomName', 'someBodyNotHere')
      result = core.listParticipants('roomName')
      result.should.eql({participant1: null})

  describe 'getData()', ->
    it 'should return blank object when cache is undefined', ->
      result = core.getData('roomName')
      result.should.eql({})

    it 'should return blank object when cache is null', ->
      cache.put('roomName', null)
      result = core.getData('roomName')
      result.should.eql({})

    it 'should return data when cache has data', ->
      anyData = {'anyData'}
      cache.put('roomName', anyData)
      result = core.getData('roomName')
      result.should.eql(anyData)

  describe 'ensureRoomExist()', ->
    it 'should put blank object into room if cache.get(room) is null.', ->
      cache.put('roomName', null)
      core.ensureRoomExist('roomName')
      result = cache.get('roomName')
      result.should.eql({})

    it 'should put blank object into room if cache.get(room) is undefined.', ->
      core.ensureRoomExist('roomName')
      result = cache.get('roomName')
      result.should.eql({})

  describe 'vote()', ->
    it 'should put cast result to participant', ->
      expectResult = {participants: {participant1: 2}}
      setupParticipant('roomName', 1)
      core.vote('roomName', 'participant1', 2)
      result = cache.get('roomName')
      result.should.eql(expectResult)
)