<!---->
<!--  Created by An An on 17/1/16.-->
<!--  Copyright © 2017年 An An. All rights reserved.-->
<!--  source code ----*** https://github.com/AAChartModel/AAChartKit ***--- source code-->
<!---->

/*
 
 * -------------------------------------------------------------------------------
 *
 * ❀❀❀   WARM TIPS!!!   ❀❀❀
 *
 * Please contact me on GitHub,if there are any problems encountered in use.
 * GitHub Issues : https://github.com/AAChartModel/AAChartKit/issues
 * -------------------------------------------------------------------------------
 * And if you want to contribute for this project, please contact me as well
 * GitHub        : https://github.com/AAChartModel
 * StackOverflow : https://stackoverflow.com/users/7842508/codeforu
 * JianShu       : http://www.jianshu.com/u/f1e6753d4254
 * SegmentFault  : https://segmentfault.com/u/huanghunbieguan
 *
 * -------------------------------------------------------------------------------
 
 */


/*
 Highcharts JS v5.0.14 (2017-07-28)
 Highcharts Drilldown module

 Author: Torstein Honsi
 License: www.highcharts.com/license

*/
(function(n){"object"===typeof module&&module.exports?module.exports=n:n(Highcharts)})(function(n){(function(f){var n=f.noop,A=f.color,B=f.defaultOptions,h=f.each,p=f.extend,H=f.format,C=f.objectEach,v=f.pick,r=f.wrap,q=f.Chart,w=f.seriesTypes,D=w.pie,t=w.column,E=f.Tick,x=f.fireEvent,F=f.inArray,G=1;p(B.lang,{drillUpText:"\u25c1 Back to {series.name}"});B.drilldown={activeAxisLabelStyle:{cursor:"pointer",color:"#003399",fontWeight:"bold",textDecoration:"underline"},activeDataLabelStyle:{cursor:"pointer",
color:"#003399",fontWeight:"bold",textDecoration:"underline"},animation:{duration:500},drillUpButton:{position:{align:"right",x:-10,y:10}}};f.SVGRenderer.prototype.Element.prototype.fadeIn=function(a){this.attr({opacity:.1,visibility:"inherit"}).animate({opacity:v(this.newOpacity,1)},a||{duration:250})};q.prototype.addSeriesAsDrilldown=function(a,b){this.addSingleSeriesAsDrilldown(a,b);this.applyDrilldown()};q.prototype.addSingleSeriesAsDrilldown=function(a,b){var d=a.series,c=d.xAxis,e=d.yAxis,g,
l=[],k=[],u,m,y;y={color:a.color||d.color};this.drilldownLevels||(this.drilldownLevels=[]);u=d.options._levelNumber||0;(m=this.drilldownLevels[this.drilldownLevels.length-1])&&m.levelNumber!==u&&(m=void 0);b=p(p({_ddSeriesId:G++},y),b);g=F(a,d.points);h(d.chart.series,function(b){b.xAxis!==c||b.isDrilling||(b.options._ddSeriesId=b.options._ddSeriesId||G++,b.options._colorIndex=b.userOptions._colorIndex,b.options._levelNumber=b.options._levelNumber||u,m?(l=m.levelSeries,k=m.levelSeriesOptions):(l.push(b),
k.push(b.options)))});a=p({levelNumber:u,seriesOptions:d.options,levelSeriesOptions:k,levelSeries:l,shapeArgs:a.shapeArgs,bBox:a.graphic?a.graphic.getBBox():{},color:a.isNull?(new f.Color(A)).setOpacity(0).get():A,lowerSeriesOptions:b,pointOptions:d.options.data[g],pointIndex:g,oldExtremes:{xMin:c&&c.userMin,xMax:c&&c.userMax,yMin:e&&e.userMin,yMax:e&&e.userMax}},y);this.drilldownLevels.push(a);c&&c.names&&(c.names.length=0);b=a.lowerSeries=this.addSeries(b,!1);b.options._levelNumber=u+1;c&&(c.oldPos=
c.pos,c.userMin=c.userMax=null,e.userMin=e.userMax=null);d.type===b.type&&(b.animate=b.animateDrilldown||n,b.options.animation=!0)};q.prototype.applyDrilldown=function(){var a=this.drilldownLevels,b;a&&0<a.length&&(b=a[a.length-1].levelNumber,h(this.drilldownLevels,function(a){a.levelNumber===b&&h(a.levelSeries,function(c){c.options&&c.options._levelNumber===b&&c.remove(!1)})}));this.redraw();this.showDrillUpButton()};q.prototype.getDrilldownBackText=function(){var a=this.drilldownLevels;if(a&&0<
a.length)return a=a[a.length-1],a.series=a.seriesOptions,H(this.options.lang.drillUpText,a)};q.prototype.showDrillUpButton=function(){var a=this,b=this.getDrilldownBackText(),d=a.options.drilldown.drillUpButton,c,e;this.drillUpButton?this.drillUpButton.attr({text:b}).align():(e=(c=d.theme)&&c.states,this.drillUpButton=this.renderer.button(b,null,null,function(){a.drillUp()},c,e&&e.hover,e&&e.select).addClass("highcharts-drillup-button").attr({align:d.position.align,zIndex:7}).add().align(d.position,
!1,d.relativeTo||"plotBox"))};q.prototype.drillUp=function(){for(var a=this,b=a.drilldownLevels,d=b[b.length-1].levelNumber,c=b.length,e=a.series,g,l,k,f,m=function(b){var c;h(e,function(a){a.options._ddSeriesId===b._ddSeriesId&&(c=a)});c=c||a.addSeries(b,!1);c.type===k.type&&c.animateDrillupTo&&(c.animate=c.animateDrillupTo);b===l.seriesOptions&&(f=c)};c--;)if(l=b[c],l.levelNumber===d){b.pop();k=l.lowerSeries;if(!k.chart)for(g=e.length;g--;)if(e[g].options.id===l.lowerSeriesOptions.id&&e[g].options._levelNumber===
d+1){k=e[g];break}k.xData=[];h(l.levelSeriesOptions,m);x(a,"drillup",{seriesOptions:l.seriesOptions});f.type===k.type&&(f.drilldownLevel=l,f.options.animation=a.options.drilldown.animation,k.animateDrillupFrom&&k.chart&&k.animateDrillupFrom(l));f.options._levelNumber=d;k.remove(!1);f.xAxis&&(g=l.oldExtremes,f.xAxis.setExtremes(g.xMin,g.xMax,!1),f.yAxis.setExtremes(g.yMin,g.yMax,!1))}x(a,"drillupall");this.redraw();0===this.drilldownLevels.length?this.drillUpButton=this.drillUpButton.destroy():this.drillUpButton.attr({text:this.getDrilldownBackText()}).align();
this.ddDupes.length=[]};t.prototype.animateDrillupTo=function(a){if(!a){var b=this,d=b.drilldownLevel;h(this.points,function(b){var c=b.dataLabel;b.graphic&&b.graphic.hide();c&&(c.hidden="hidden"===c.attr("visibility"),c.hidden||(c.hide(),b.connector&&b.connector.hide()))});setTimeout(function(){b.points&&h(b.points,function(b,a){a=a===(d&&d.pointIndex)?"show":"fadeIn";var c="show"===a?!0:void 0,e=b.dataLabel;if(b.graphic)b.graphic[a](c);if(e&&!e.hidden&&(e[a](c),b.connector))b.connector[a](c)})},
Math.max(this.chart.options.drilldown.animation.duration-50,0));this.animate=n}};t.prototype.animateDrilldown=function(a){var b=this,d=this.chart.drilldownLevels,c,e=this.chart.options.drilldown.animation,g=this.xAxis;a||(h(d,function(a){b.options._ddSeriesId===a.lowerSeriesOptions._ddSeriesId&&(c=a.shapeArgs,c.fill=a.color)}),c.x+=v(g.oldPos,g.pos)-g.pos,h(this.points,function(a){a.shapeArgs.fill=a.color;a.graphic&&a.graphic.attr(c).animate(p(a.shapeArgs,{fill:a.color||b.color}),e);a.dataLabel&&
a.dataLabel.fadeIn(e)}),this.animate=null)};t.prototype.animateDrillupFrom=function(a){var b=this.chart.options.drilldown.animation,d=this.group,c=d!==this.chart.seriesGroup,e=this;h(e.trackerGroups,function(b){if(e[b])e[b].on("mouseover")});c&&delete this.group;h(this.points,function(e){var g=e.graphic,k=a.shapeArgs,h=function(){g.destroy();d&&c&&(d=d.destroy())};g&&(delete e.graphic,k.fill=a.color,b?g.animate(k,f.merge(b,{complete:h})):(g.attr(k),h()))})};D&&p(D.prototype,{animateDrillupTo:t.prototype.animateDrillupTo,
animateDrillupFrom:t.prototype.animateDrillupFrom,animateDrilldown:function(a){var b=this.chart.drilldownLevels[this.chart.drilldownLevels.length-1],d=this.chart.options.drilldown.animation,c=b.shapeArgs,e=c.start,g=(c.end-e)/this.points.length;a||(h(this.points,function(a,k){var h=a.shapeArgs;c.fill=b.color;h.fill=a.color;if(a.graphic)a.graphic.attr(f.merge(c,{start:e+k*g,end:e+(k+1)*g}))[d?"animate":"attr"](h,d)}),this.animate=null)}});f.Point.prototype.doDrilldown=function(a,b,d){var c=this.series.chart,
e=c.options.drilldown,g=(e.series||[]).length,f;c.ddDupes||(c.ddDupes=[]);for(;g--&&!f;)e.series[g].id===this.drilldown&&-1===F(this.drilldown,c.ddDupes)&&(f=e.series[g],c.ddDupes.push(this.drilldown));x(c,"drilldown",{point:this,seriesOptions:f,category:b,originalEvent:d,points:void 0!==b&&this.series.xAxis.getDDPoints(b).slice(0)},function(b){var c=b.point.series&&b.point.series.chart,d=b.seriesOptions;c&&d&&(a?c.addSingleSeriesAsDrilldown(b.point,d):c.addSeriesAsDrilldown(b.point,d))})};f.Axis.prototype.drilldownCategory=
function(a,b){C(this.getDDPoints(a),function(d){d&&d.series&&d.series.visible&&d.doDrilldown&&d.doDrilldown(!0,a,b)});this.chart.applyDrilldown()};f.Axis.prototype.getDDPoints=function(a){var b=[];h(this.series,function(d){var c,e=d.xData,g=d.points;for(c=0;c<e.length;c++)if(e[c]===a&&d.options.data[c]&&d.options.data[c].drilldown){b.push(g?g[c]:!0);break}});return b};E.prototype.drillable=function(){var a=this.pos,b=this.label,d=this.axis,c="xAxis"===d.coll&&d.getDDPoints,e=c&&d.getDDPoints(a);c&&
(b&&e.length?(b.drillable=!0,b.basicStyles||(b.basicStyles=f.merge(b.styles)),b.addClass("highcharts-drilldown-axis-label").css(d.chart.options.drilldown.activeAxisLabelStyle).on("click",function(b){d.drilldownCategory(a,b)})):b&&b.drillable&&(b.styles={},b.css(b.basicStyles),b.on("click",null),b.removeClass("highcharts-drilldown-axis-label")))};r(E.prototype,"addLabel",function(a){a.call(this);this.drillable()});r(f.Point.prototype,"init",function(a,b,d,c){var e=a.call(this,b,d,c);c=(a=b.xAxis)&&
a.ticks[c];e.drilldown&&f.addEvent(e,"click",function(a){b.xAxis&&!1===b.chart.options.drilldown.allowPointDrilldown?b.xAxis.drilldownCategory(e.x,a):e.doDrilldown(void 0,void 0,a)});c&&c.drillable();return e});r(f.Series.prototype,"drawDataLabels",function(a){var b=this.chart.options.drilldown.activeDataLabelStyle,d=this.chart.renderer;a.call(this);h(this.points,function(a){var c=a.options.dataLabels,f=v(a.dlOptions,c&&c.style,{});a.drilldown&&a.dataLabel&&("contrast"===b.color&&(f.color=d.getContrast(a.color||
this.color)),c&&c.color&&(f.color=c.color),a.dataLabel.addClass("highcharts-drilldown-data-label"),a.dataLabel.css(b).css(f))},this)});var z=function(a,b,d){a[d?"addClass":"removeClass"]("highcharts-drilldown-point");a.css({cursor:b})},I=function(a){a.call(this);h(this.points,function(a){a.drilldown&&a.graphic&&z(a.graphic,"pointer",!0)})},J=function(a,b){var d=a.apply(this,Array.prototype.slice.call(arguments,1));this.drilldown&&this.series.halo&&"hover"===b?z(this.series.halo,"pointer",!0):this.series.halo&&
z(this.series.halo,"auto",!1);return d};C(w,function(a){r(a.prototype,"drawTracker",I);r(a.prototype.pointClass.prototype,"setState",J)})})(n)});
