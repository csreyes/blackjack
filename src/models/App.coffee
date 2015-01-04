# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', new Deck()
    @set 'playerChips', 500
    @set 'currentBet', 10
    @set 'playStateOn', false
    @newHand()

  playerBust: ->
    callback = =>
      alert('Player Busted !')
      @payOut(false)
      @set 'playStateOn', false
    setTimeout callback, 100

  playerStand: ->
    @get('dealerHand').at(0).flip()
    @get('dealerHand').hit()

  dealerBust: ->
    callback = =>
      alert('Dealer Busted!')
      @payOut(true)
      @set 'playStateOn', false
    setTimeout callback, 100

  dealerStand: ->
    callback = =>
      @compareHands()
      @set 'playStateOn', false
    setTimeout callback, 100

  newHand: ->
    if @get('deck').length <= 10
      @set 'deck', new Deck()
    @set 'playerHand', @get('deck').dealPlayer()
    @set 'dealerHand', @get('deck').dealDealer()
    @get('playerHand').on('playerBust', @playerBust, this)
    @get('playerHand').on('stand', @playerStand, this)
    @get('playerHand').on('hit', @sendHit, this)
    @get('dealerHand').on('dealerBust', @dealerBust, this )
    @get('dealerHand').on('dealerStand', @dealerStand, this)
    @trigger('newHand')

  compareHands: ->
    playerHand = @get('playerHand')
    if @get('playerHand').hasAce()
      if playerHand.scores()[1] <= 21
        playerScore = @get('playerHand').scores()[1]
      else
        playerScore = @get('playerHand').scores()[0]
    else
      playerScore = @get('playerHand').scores()[0]

    dealerScore = @get('dealerHand').scores()[0]
    if playerScore > dealerScore
      alert('Player Wins!')
      @payOut(true)
    else if playerScore == dealerScore
      alert('Push!')
      @set 'currentBet', 10
    else
      alert('Dealer Wins!')
      @payOut(false)

  play: ->
    @set 'playStateOn', true
    if @get('playerHand').scores()[1] == 21
      callback = ->
        alert('blackjack')
        @payOut(true)
        @set 'playStateOn', false
      setTimeout(callback.bind(@), 100)

  addBet: ->
    if @get('currentBet') < @get('playerChips') && !@get('playState')
      @set 'currentBet', @get('currentBet')+10

  removeBet: ->
    if @get('currentBet') > 10 && !@get('playState')
      @set 'currentBet', @get('currentBet')-10

  payOut: (win)->
    if win
      @set 'playerChips', @get('playerChips') + @get('currentBet')
    else
      @set 'playerChips', @get('playerChips') - @get('currentBet')
      if @get('playerChips') <= 0
        alert('You Lose!')
        location.reload()
    @set 'currentBet', 10
    @newHand()

  doubleDown: ->
    @set 'currentBet', @get('currentBet') * 2
    @get('playerHand').hit()
    if @get('playerHand').scores()[0] <= 21
      @get('playerHand').stand()

  sendHit: ->
    @trigger('sendHit')
