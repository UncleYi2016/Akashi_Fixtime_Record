path = require 'path-extra'
{relative, join} = require 'path-extra'
{$, _, $$, React, ReactBootstrap, FontAwesome, ROOT, layout} = window
{_ships, $ships, $shipTypes} = window
{Alert, Grid, Col, Input, DropdownButton, Table, MenuItem, Button} = ReactBootstrap

window.i18n.Test = new(require 'i18n-2')
  locales: ['en-US', 'ja-JP', 'zh-CN', 'zh-TW']
  defaultLocale: 'zh-CN'
  directory: path.join(__dirname, 'assets', 'i18n')
  updateFiles: false
  indent: '\t'
  extension: '.json'
window.i18n.Test.setLocale(window.language)
__ = window.i18n.Test.__.bind(window.i18n.Test)

row = if layout == 'horizontal' then 6 else 3
shipRow = if layout == 'horizontal' then 12 else 5
mapRow = if layout == 'horizontal' then 9 else 5
rankRow = if layout == 'horizontal' then 3 else 2

window.addEventListener 'layout.change', (e) ->
  {layout} = e.detail
  row = if layout == 'horizontal' then 6 else 3
  shipRow = if layout == 'horizontal' then 12 else 5
  mapRow = if layout == 'horizontal' then 9 else 5
  rankRow = if layout == 'horizontal' then 3 else 2

testAkashi = (e) -> 
  flagShipId = this.deck[0]
  if window._ships[flagShipId].api_name == '明石' || window._ships[flagShipId].api_name == '明石改'
    this.isAkashiFlagShip = true
  else
    this.isAkashiFlagShip = false
  return

module.exports =
  name: 'AkashiFixTime'
  priority: 2
  displayName: <span><FontAwesome key={0} name='calculator' />Test</span>
  description: __("Exp calculator")
  author: 'UncleYi'
  link: 'https://github.com/yizhaopu'
  version: '0.0.1'
  reactClass: React.createClass
    getInitialState: ->
      deckArray: [
        {deckNo: 0, isAkashiFlagShip: false, fixTime: 0, deck: [], intervalID: null, timer: false, testAkashi: testAkashi},
        {deckNo: 1, isAkashiFlagShip: false, fixTime: 0, deck: [], intervalID: null, timer: false, testAkashi: testAkashi},
        {deckNo: 2, isAkashiFlagShip: false, fixTime: 0, deck: [], intervalID: null, timer: false, testAkashi: testAkashi},
        {deckNo: 3, isAkashiFlagShip: false, fixTime: 0, deck: [], intervalID: null, timer: false, testAkashi: testAkashi},
      ]
    handleResponse: (e) ->
      {method, path, body, postBody} = e.detail
      if window._ship != null && window._decks != null || typeof(window._decks) != undefined && typeof(window._ship) != undefined
        deckNo = 0;
        for deck in window._decks
          @state.deckArray[deckNo].deck = deck.api_ship
          @state.deckArray[deckNo].testAkashi e
          @start deckNo++
        return
    componentDidMount: ->
      window.addEventListener 'game.response', @handleResponse
    componentWillUnmount: ->
      window.removeEventListener 'game.response', @handleResponse
    start: (deckNo) ->
      currDeck = @state.deckArray[deckNo]
      if currDeck.isAkashiFlagShip == true
        if currDeck.timer == false
          currDeck.intervalID = setInterval(@refreshTime, 1000, deckNo)
          currDeck.timer = true
          return
      else
        clearInterval(currDeck.intervalID)
        currDeck.fixTime = 0
        currDeck.timer = false
    refreshTime: (deckNo) ->
      time = @state.deckArray[deckNo].fixTime
      time++
      @state.deckArray[deckNo].fixTime = time
      currDeckArr = @state.deckArray
      @setState
        deckArray: currDeckArr
      return
    render: ->  
      <div>
        <table>
          <tr>
            <td><Input type="text" label="第一舰队" value={@state.deckArray[0].isAkashiFlagShip}></Input></td>
            <td><Input type="text" label="修理时间" value={@state.deckArray[0].fixTime}></Input></td>
          </tr>
          <tr>
            <td><Input type="text" label="第二舰队" value={@state.deckArray[1].isAkashiFlagShip}></Input></td>
            <td><Input type="text" label="修理时间" value={@state.deckArray[1].fixTime}></Input></td>
            </tr>
          <tr>
            <td><Input type="text" label="第三舰队" value={@state.deckArray[2].isAkashiFlagShip}></Input></td>
            <td><Input type="text" label="修理时间" value={@state.deckArray[2].fixTime}></Input></td>
          </tr>
          <tr>
            <td><Input type="text" label="第四舰队" value={@state.deckArray[3].isAkashiFlagShip}></Input></td>
            <td><Input type="text" label="修理时间" value={@state.deckArray[3].fixTime}></Input></td>
          </tr>
        </table>
      </div>
    
    
