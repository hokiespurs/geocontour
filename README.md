# geocontour
**2D Contour** | **May 9, 2018** | **Elevation Data as JSON** | **Contributors:** [Richie Slocum](https://github.com/hokiespurs)

![mthood](https://github.com/hokiespurs/geocontour/blob/master/img/hood.gif?raw=true)

This module generates a contour map from gridded 2D elevation data using the D3 contour javascript library.  This code is based on the [bl.ocks example](https://bl.ocks.org/mbostock/4241134) by Mike Bostocks.

## 1\. Set up the workspace

## 2\. Data Sources
Elevation geotiff data can be downloaded from the USGS tool, [Earth Explorer](https://earthexplorer.usgs.gov/).  Following the instructions on the webpage:
- draw a bounding box for your area of interest
- filter by digital elevation data
- download a geotiff of elevation data for the selected site. 
![Earth Explorer](https://github.com/hokiespurs/geocontour/blob/master/img/earthexplorer.png?raw=true)

Once the geotiff is downloaded, the data must be clipped, downsampled, and saved to a json file.  A Matlab script, located at `geocontour/matlab/downsampledata.m`, is provided to trim the data.  The Matlab script also outputs the variables xi and yi, which are used to set the UTM bounds of the data for the axes.

**downsampledata.m**
```matlab
%% Constants
OFFSET = 100;
FNAME = 'C:\tmp\hood.tif';

%% Download and Resize
hood = importdata(FNAME);
[m,n]=size(hood);
X = hood(1+OFFSET:m-OFFSET,1+OFFSET:n-OFFSET);
sX = imresize(X,[100,100]);

%% Export Data as 100x100 Json
fid = fopen('mthood.json','w+t');
fprintf(fid,'{"width":100,"height":100,"values":[');
fprintf(fid,'%i,',sX(1:end-1));
fprintf(fid,'%i]}',sX(end));
fclose(fid);

%% Get X and Y coords
[a,b,c] = geotiffread(FNAME);
[x,y,zone]=deg2utm(c(:,2),c(:,1));

xi = linspace(x(1),x(2),m);
yi = linspace(y(1),y(2),n);

xis = xi(1+OFFSET:m-OFFSET);
yis = yi(1+OFFSET:m-OFFSET);

fprintf('var xi = [%.2f, %.2f];\n',xis(1),xis(end));
fprintf('var yi = [%.2f, %.2f];\n',yis(1),yis(end));
```
The xi and yi variables printed to the screen represent UTM coordinates for the x and y axes and should be copied into the main.js file, as described in the next section.  The json file should be saved to the assets folder.  While this method generates a json file using Matlab, any method that creates a json file formatted as shown below will generate correct results.
```
{"width":100,"height":100,"values":[z11,z12,z13,...,zNN]}
```
* Here, zNN represents the z elevation of the 100th row and 100th column.

## 3\. A function-by-function Tutorial
### Folder Structure
The basic folder structure to generate a contour plot should be as follows:
```
|-- geocontour
    |-- index.html
    |-- assets
    |   |-- mthood.json
    |-- css
    |   |-- main.css
    |-- js
    |   |-- main.js
```
<hr>

### HTML
The html document should first call the relevant libraries, and title the document.
``` html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mount Hood D3 Contours</title>
    <link rel="stylesheet" href="css/main.css" />
    <script src="https://d3js.org/d3.v4.min.js"></script>
    <script src="https://d3js.org/d3-hsv.v0.1.min.js"></script>
    <script src="https://d3js.org/d3-contour.v1.min.js"></script>
</head>
```

Then, the svg tag is added to the body, and a rectangle is added to outline the actual contour plot.
``` html
<body>
<svg width="400" height="400" stroke="#fff" stroke-width="0.5">
    <rect x="65" y="30" width="305" height="305" stroke="#5581ba" fill="white"/>
</svg>
```

The constants which depict the
- zrange (minimum and maximum elevation to add contours)
- dZ (delta elevation between contours)
- xi,yi (easting and northing bounds)
- FNAME (relative path to the json file)
``` html
<script>
    // CONSTANTS
    var ZRANGE = [1100, 3500];
    var dZ = 75;
    var xi = [598.80121, 605.26936];   // Easting (km)
    var yi = [5020.50918, 5030.00915]; // Northing (km)
    var FNAME = "assets/mthood.json";
</script>
```

Finally, the main.js script is added.
``` html
<script src="js/main.js"></script>

</body>
</html>
```
<hr>
### JAVASCRIPT


### CSS
A stylesheet is added to style the text and lines on the plot.

The axis class is used to style the numerical text along each axis.
```css
.axis{
    font-family: 'Open Sans', sans-serif;
    font-size: 12px;
    font-weight: bold;
}
```
The axislabel is used to style the axis labels ("Easting" and "Northing")
```css
.axislabel{
    font-family: 'Open Sans', sans-serif;
    font-size: 16px;
    font-weight: bold;
}
```
The axis line and axis path are used to color the axes black
``` css
.axis line {
    stroke: #000000;
}

.axis path {
    stroke: #000000;
}
```

The display:none property of the path is used to remove the axes line, except for the tick marks.
``` css
.axis--x path {
    display: none;
}
.axis--y path {
    display: none;
}
```

The text fill property is used to color the text black.
``` css
text {
    fill: #000000;
}
```

## 4\. More examples of similiar geovisualizations

## Acknowledgement
- [D3.js](https://d3js.org/) (Mike Bostocks)
- [D3 Contour Example](https://bl.ocks.org/mbostock/4241134) (Mike Bostocks)
- [deg2utm](https://www.mathworks.com/matlabcentral/fileexchange/10915-deg2utm) (Rafael Palacios)
- [Mt Hood Elevation Data](https://earthexplorer.usgs.gov/) (USGS Earth Explorer)

## References
