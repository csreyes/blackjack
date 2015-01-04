class window.AppView extends Backbone.View
  template: _.template '
    <div class="dealer-hand-container"></div>
    <div class="player-hand-container"></div>
    <div class="button-container">
      <button class="play-button btn btn-primary btn-lg">Play</button>
        <br>
      <button class="hit-button btn btn-default btn-lg">Hit</button> <button class="stand-button btn btn-default btn-lg">Stand</button>
      <button class="double-button btn btn-default btn-lg">DoubleDown</button>
      <button class="addBet-button btn btn-default btn-lg">Increase Bet</button>
      <button class="removeBet-button btn btn-default btn-lg">Decrease Bet</button>
      <button class="playerChips btn btn-default btn-lg" disabled="disabled">Current Bet: <%= currentBet %></button>
      <button class="playerChips btn btn-default btn-lg" disabled="disabled">Total Chips: <%= playerChips %></button>
    </div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('playerHand').stand()
    'click .addBet-button': -> @model.addBet()
    'click .removeBet-button': -> @model.removeBet()
    'click .play-button': -> @model.play()
    'click .double-button': -> @model.doubleDown()


  initialize: ->
    @render()
    @model.on('newHand', @render, this)
    @$el.addClass('gameContainer')
    @model.on('change:currentBet', @render, this)
    @model.on('change:playStateOn', @render, this)
    @model.on('change', @render, this)
    @model.on('sendHit', @hideDouble, this)
    # @model.get('playerHand').on('hit', @hideDouble, this)

  addEvent: ->
    console.log('resetting')
    @model.get('playerHand').on('hit', @hideDouble, this)

  render: ->
    @$el.children().detach()
    @$el.html @template(@model.attributes)
    if !@model.get('playStateOn')
      @$('.hit-button').hide()
      @$('.stand-button').hide()
      @$('.player-hand-container').hide()
      @$('.dealer-hand-container').hide()
      @$('.double-button').hide()
    else
      @$('.addBet-button').hide()
      @$('.removeBet-button').hide()
      @$('.play-button').hide()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

  hideDouble: ->
    console.log('first')
    @$('.double-button').hide()

  # addChips: ->
  #   chips = @model.get('playerChips')
  #   @$el.append("<button type='button' class='playerChips btn btn-success' disabled='disabled'>#{chips}</button>")

  # renderBet: ->
  #   bet = @model.get('currentBet')
  #   @$el.append("<button type='button' class='playerChips btn btn-success' disabled='disabled'>#{bet}</button>")
