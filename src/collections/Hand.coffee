class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    if !@isDealer
      newCard = @deck.pop()
      @add(newCard)
      if @isBust()
        @trigger('playerBust')
      return newCard
    else
      if !@dealerCheck()
        newCard = @deck.pop()
        @add(newCard)
        if @isBust()
          @trigger('dealerBust')
        else
          @hit()
      else
        @trigger('dealerStand')
      return newCard

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  isBust: ->
    @scores()[0] > 21


  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    if (@hasAce() && !@isDealer && @minScore()+10 < 21) || (@hasAce() && @isDealer && @at(1).get('rank') == 1 && @minScore()+10 < 21)
      [@minScore(), @minScore() + 10]
    else
      [@minScore()]

  stand: ->
    @trigger('stand')

  dealerCheck: ->
    @scores()[0] >= 17


