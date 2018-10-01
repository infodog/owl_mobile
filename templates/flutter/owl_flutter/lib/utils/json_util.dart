dynamic getAttr(node, attrName) {
  List attrs = node['attrs'];
  if (attrs == null) {
    return null;
  }
  for (int i = 0; i < attrs.length; i++) {
    var attr = attrs[i];
    if (attr['name'] == attrName) {
      return attr['value'];
    }
  }
  return null;
}
