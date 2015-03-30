function checkStyle(style, prefix, suffix, value) {
  return style.getPropertyValue(prefix + '-top' + suffix) == value ||
    style.getPropertyValue(prefix + '-right' + suffix) == value ||
    style.getPropertyValue(prefix + '-bottom' + suffix) == value ||
    style.getPropertyValue(prefix + '-left' + suffix) == value;
}