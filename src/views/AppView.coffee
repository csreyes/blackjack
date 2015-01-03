class window.AppView extends Backbone.View
  template: _.template '
    <div class="dealer-hand-container"></div>
    <div class="player-hand-container"></div>
    <button class="hit-button btn btn-default btn-lg">Hit</button> <button class="stand-button btn btn-default btn-lg">Stand</button>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('playerHand').stand()

  initialize: ->
    @render()
    @model.on('newHand', @render, this)
    @$el.addClass('gameContainer')

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

