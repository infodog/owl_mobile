String getMiddle(String s, String beginTag, String endTag) {
  int beginPos = s.indexOf(beginTag);
  if (beginPos < 0) {
    return null;
  }
  beginPos = beginPos + beginTag.length;

  int endPos = s.indexOf(endTag);
  if (endPos < 0) {
    return null;
  }
  return s.substring(beginPos, endPos);
}

dynamic getPlainAttr(node, attrName) {
  if (node is String) {
    return null;
  }
  List attrs = node['attrs'];
  if (attrs == null) {
    return null;
  }
  for (int i = 0; i < attrs.length; i++) {
    var attr = attrs[i];
    if (attr['name'] == attrName) {
      String result = attr['value'];
      if (result == null) {
        return null;
      }
      return result;
    }
  }
  return null;
}
