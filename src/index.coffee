class Game
  WIDTH = 800
  HEIGHT = 400

  constructor: () ->
    # create an new instance of a pixi stage
    @stage = new PIXI.Stage(0xEEEEEE)
    @renderer = PIXI.autoDetectRenderer(WIDTH, HEIGHT)
    document.body.appendChild(@renderer.view)

  run: () =>
      requestAnimFrame(@run)
      @renderer.render(@stage)

  addNode: (node) =>
    @stage.addChild(node)



class Node extends PIXI.Sprite
  SIZE: 10

  backgroundColor = 0x85b9bb
  borderColor = 0x476263

  constructor: (x, y) ->
    graphics = new PIXI.Graphics()
    graphics.beginFill(backgroundColor)
    graphics.lineStyle(1, borderColor, 1)
    graphics.drawCircle(0, 0, @SIZE)
    graphics.endFill()

    texture = graphics.generateTexture()
    super texture

    @interactive = true
    @position.x = x
    @position.y = y
    @anchor.x = 0.5
    @anchor.y = 0.5

  mousedown: (touchData) ->
    console.log("DOWN!")

# $ ->
game = new Game
requestAnimFrame game.run

testnode = new Node(40, 100)
game.addNode(testnode)


