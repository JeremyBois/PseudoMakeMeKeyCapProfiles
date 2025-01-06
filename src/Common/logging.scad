// HTML support seems to be disabled
// module echo_color(color, text) echo(str("<b style='color:",color,"'>", text, "</b>"));
// module echo_color(color, text) echo(str("<font color=",color,">",text,"</font>"));
module echo_color(_, text) echo(text);

module echo_debug(text) echo_color("black", str("*** DEBUG ***  ", text));
module echo_info(text) echo_color("green", str("*** INFO ***  ", text));
module echo_warn(text) echo_color("orange", str("*** WARNING ***  ", text));
module echo_error(text) echo_color("red", str("*** ERROR ***  ", text));
