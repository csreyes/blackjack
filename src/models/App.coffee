# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', new Deck()
    @newHand()

  playerBust: ->
    alert('Player Busted !')
    @newHand()

  playerStand: ->
    @get('dealerHand').at(0).flip()
    @get('dealerHand').hit()

  dealerBust: ->
    alert('dealerbusted')
    @newHand()

  dealerStand: ->
    @compareHands()
    @newHand()

  newHand: ->
    if @get('deck').length <= 10
      @set 'deck', new Deck()
    @set 'playerHand', @get('deck').dealPlayer()
    @set 'dealerHand', @get('deck').dealDealer()
    @get('playerHand').on('playerBust', @playerBust, this)
    @get('playerHand').on('stand', @playerStand, this)
    @get('dealerHand').on('dealerBust', @dealerBust, this )
    @get('dealerHand').on('dealerStand', @dealerStand, this)
    @trigger('newHand')
    if @get('playerHand').scores()[1] == 21
      alert('BlackJack!')
      @newHand()

  compareHands: ->
    playerHand = @get('playerHand')
    if @get('playerHand').hasAce()
      if playerHand.scores()[1] < 21
        playerScore = @get('playerHand').scores()[1]
      else
        playerScore = @get('playerHand').scores()[0]
    else
      playerScore = @get('playerHand').scores()[0]



    dealerScore = @get('dealerHand').scores()[0]
    if playerScore > dealerScore
      alert('Player Wins!')
    else if playerScore == dealerScore
      alert('Push!')
    else
      alert('Dealer Wins!')
