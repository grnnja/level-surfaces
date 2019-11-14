# Level Surfaces: an OpenSCAD based 3D surface grapher
## with special 3D printing functionality

Level surfaces helps you graph and understand 3D functions. You can not only render 3D functions, but you can export surfaces to STL files. 

### Demo
![frame00001](https://user-images.githubusercontent.com/31556469/67651733-86987c80-f8ff-11e9-9bec-b753b0f5782d.png)
![hypberbolalq](https://user-images.githubusercontent.com/31556469/67654150-d2502380-f909-11e9-86e8-9986d2392e27.gif)

## Making Animations

1. Add $t to f(x, y, z)
    * $t varies from 0 to 1 over the course of the animation
    * Example:
      * The constant in this function changes from -10 to 10
      * `function f(x, y, z) = pow(x, 2) + pow(y, 2) - pow(z, 2) - 10 + 20 * $t;`
    * More information about animation in OpenSCAD [link](https://blog.prusaprinters.org/how-to-animate-models-in-openscad/)

2. Move the camera where you want to be in the animation or use the built in variables to set the camera location
3. Select dump pictures
3. Set fps to 1 at the bottom of the screen
4. Set steps to the number frames you want
5. Wait to complete rendering
    * OpenSCAD will output a series of images into the same folder as level-surfaces.scad
6. To turn the images into a gif or video
    * Use an online [png to gif converter](https://ezgif.com/apng-to-gif)
    * Or use [ffmpeg](https://www.ffmpeg.org/) with a command similar to: `ffmpeg -framerate 60 -i frame%05d.png video-name.gif`



## FAQ


### How does it work?

The rendering system uses a  [Marching Cubes](https://en.wikipedia.org/wiki/Marching_cubes) algorithm to take points from the function and translate them to a 3D model. This works by extracting data points from the function and then creating a polygonal mesh field based on the cube's intersections.


### About rendering algorithms.

Several algorithms for tracing 3D objects exist. [These methods](https://en.wikipedia.org/wiki/Isosurface) (sphere tracing, marching cubes, level set, dual contouring, etc) extract points to express density or orientation of points.
