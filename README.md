cqimg
==========

## Installation

```
git clone https://github.com/drewlanenga/cqimg
npm install
node lib/index.js
```

That will host the service on http://localhost:3000

## Options

The following query params are available

| Param          | Default  | Description |
| -------------- | -------- | ----------- |
| w              | 800      | Height of the chart body |
| h              | 450      | Width of the chart body |
| padding        | 20       | Chart Padding |
| retina         | false    | Should the resolution be 2x? |
| title          | Title    | Title in (optional) header |
| subtitle       | Subtitle | Subtitle in (optional) header |
| includeHeader  | false    | Should a header be included? |
| includeFooter  | false    | Should a footer be included? |
| includeBumpers | false    | Bumpers are kind of like gridlines for debgging.  Should they be included? |
| startDate      | N/A      | Beginning date on (optional) footer |
| endDate        | N/A      | End date on (optional) footer |

##  Examples

| type | url |
| ---- | --- |
| collaboration	| http://localhost:3000/collaboration?w=700&h=350&data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22team1%22%2C%22name%22%3A%22Management%22%2C%22engage%22%3A32%2C%22explore%22%3A12%7D%2C%7B%22id%22%3A%22team2%22%2C%22name%22%3A%22Sales%22%2C%22engage%22%3A87%2C%22explore%22%3A43%7D%2C%7B%22id%22%3A%22team3%22%2C%22name%22%3A%22Accounting%22%2C%22engage%22%3A50%2C%22explore%22%3A199%7D%2C%7B%22id%22%3A%22team4%22%2C%22name%22%3A%22Support%22%2C%22engage%22%3A80%2C%22explore%22%3A36%7D%2C%7B%22id%22%3A%22team5%22%2C%22name%22%3A%22Warehouse%22%2C%22engage%22%3A12%2C%22explore%22%3A85%7D%5D%2C%22edges%22%3A%5B%7B%22from%22%3A%22team1%22%2C%22to%22%3A%22team2%22%2C%22explore%22%3A20%7D%2C%7B%22from%22%3A%22team1%22%2C%22to%22%3A%22team3%22%2C%22explore%22%3A11%7D%2C%7B%22from%22%3A%22team1%22%2C%22to%22%3A%22team5%22%2C%22explore%22%3A2%7D%2C%7B%22from%22%3A%22team2%22%2C%22to%22%3A%22team3%22%2C%22explore%22%3A16%7D%2C%7B%22from%22%3A%22team2%22%2C%22to%22%3A%22team4%22%2C%22explore%22%3A1%7D%2C%7B%22from%22%3A%22team2%22%2C%22to%22%3A%22team5%22%2C%22explore%22%3A3%7D%2C%7B%22from%22%3A%22team3%22%2C%22to%22%3A%22team5%22%2C%22explore%22%3A2%7D%2C%7B%22from%22%3A%22team4%22%2C%22to%22%3A%22team5%22%2C%22explore%22%3A1%7D%5D%7D |
| radar	        | http://localhost:3000/radar?w=700&h=350&data=%7B%22radar%22%3A%7B%22actual%22%3A%5B%7B%22name%22%3A%22Collaboration%22%2C%22value%22%3A16%7D%2C%7B%22name%22%3A%22Buzz%22%2C%22value%22%3A100%7D%2C%7B%22name%22%3A%22Exploration%22%2C%22value%22%3A50%7D%2C%7B%22name%22%3A%22Transparency%22%2C%22value%22%3A79%7D%5D%2C%22benchmark%22%3A%5B%7B%22name%22%3A%22Collaboration%22%2C%22value%22%3A56%7D%2C%7B%22name%22%3A%22Buzz%22%2C%22value%22%3A50%7D%2C%7B%22name%22%3A%22Exploration%22%2C%22value%22%3A20%7D%2C%7B%22name%22%3A%22Transparency%22%2C%22value%22%3A60%7D%5D%7D%7D |
| karma         | http://localhost:3000/karma?w=700&h=500&data=%7B%22karma%22%3A%5B%7B%22name%22%3A%22Michael%22%2C%22value%22%3A4%7D%2C%7B%22name%22%3A%22Dwight%22%2C%22value%22%3A10%7D%2C%7B%22name%22%3A%22Jim%22%2C%22value%22%3A100%7D%2C%7B%22name%22%3A%22Phyllis%22%2C%22value%22%3A58%7D%2C%7B%22name%22%3A%22Toby%22%2C%22value%22%3A40%7D%2C%7B%22name%22%3A%22Angela%22%2C%22value%22%3A35%7D%2C%7B%22name%22%3A%22Kevin%22%2C%22value%22%3A78%7D%2C%7B%22name%22%3A%22Oscar%22%2C%22value%22%3A64%7D%2C%7B%22name%22%3A%22Kelly%22%2C%22value%22%3A41%7D%2C%7B%22name%22%3A%22Darryl%22%2C%22value%22%3A22%7D%5D%2C%22maxKarmaDims%22%3A%7B%22rows%22%3A2%2C%22cols%22%3A5%7D%7D |
| bar	        | http://localhost:3000/bars?w=700&h=500&data=%7B%22bars%22%3A%5B%7B%22name%22%3A%22High%20Connectedness%22%2C%22bars%22%3A%5B%7B%22id%22%3A%22angela-martin%22%2C%22name%22%3A%22Angela%22%2C%22value%22%3A94%7D%2C%7B%22id%22%3A%22dwight-schrute%22%2C%22name%22%3A%22Dwight%22%2C%22value%22%3A90%7D%2C%7B%22id%22%3A%22jim-halpert%22%2C%22name%22%3A%22Jim%22%2C%22value%22%3A89%7D%2C%7B%22id%22%3A%22kevin-malone%22%2C%22name%22%3A%22Kevin%22%2C%22value%22%3A84%7D%5D%7D%2C%7B%22name%22%3A%22Low%20Connectedness%22%2C%22bars%22%3A%5B%7B%22id%22%3A%22michael-scott%22%2C%22name%22%3A%22Michael%22%2C%22value%22%3A24%7D%2C%7B%22id%22%3A%22oscar-martinez%22%2C%22name%22%3A%22Oscar%22%2C%22value%22%3A22%7D%2C%7B%22id%22%3A%22pam-beesly%22%2C%22name%22%3A%22Pam%22%2C%22value%22%3A15%7D%2C%7B%22id%22%3A%22tony-flenderson%22%2C%22name%22%3A%22Tony%22%2C%22value%22%3A14%7D%5D%7D%5D%7D |

## Development

```
coffee --bare --watch --compile --output lib/ src/
```
