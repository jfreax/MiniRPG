WIDTH = 700
HEIGHT = 300

# create an new instance of a pixi stage
stage = new PIXI.Stage(0xEEFFFF)
renderer = PIXI.autoDetectRenderer(WIDTH, HEIGHT)
document.body.appendChild(renderer.view)


node = (backgroundColor, borderColor, x, y) ->
    graphics = new PIXI.Graphics()

    graphics.beginFill(backgroundColor)
    graphics.lineStyle(1, borderColor, 1)
    graphics.drawCircle(0, 0, 10.0)
    graphics.endFill()

    sprite = new PIXI.Sprite(graphics.generateTexture())
    sprite.position.x = x
    sprite.position.y = y

    return sprite


sprite = node(0x85b9bb, 0x476263, 10, 100)
sprite.setInteractive(true)
sprite.mousedown = (touchData) ->
    console.log("DOWN!")

stage.addChild(sprite)

animate = () ->
    requestAnimFrame(animate);

    # render the stage
    renderer.render(stage)
requestAnimFrame( animate );