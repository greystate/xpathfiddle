using System;
using System.Xml;
using System.Xml.XPath;
using uComponents.Core.Shared;
using umbraco;

namespace XPathFiddle
{
	[XsltExtension("xpath.fiddle")]
	public class XsltExtensions
	{
		public static XPathNodeIterator FilterNodes(XPathNodeIterator nodeset, string xpath)
		{
			try
			{
				while (nodeset.MoveNext())
				{
					var nav = nodeset.Current;
					var manager = new XmlNamespaceManager(nav.NameTable);

					nav.MoveToFollowing(XPathNodeType.Element);

					foreach (var ns in nav.GetNamespacesInScope(XmlNamespaceScope.All))
					{
						manager.AddNamespace(ns.Key, ns.Value);
					}

					var result = nav.Evaluate(xpath, manager);
					if (result is XPathNodeIterator) {
						return (XPathNodeIterator)result;
					} else { // (result is String) {
						XmlDocument doc = new XmlDocument();
//						doc.LoadXml("<result expression=\"" + xpath + "\">" + result + "</result>");
						doc.LoadXml("<result expression=\"count(*)\">5</result>");
						return (XPathNodeIterator)doc.DocumentElement.FirstChild.CreateNavigator().Evaluate(".");
					}
				}
			}
			catch (Exception ex)
			{
				return ex.ToXPathNodeIterator();
			}

			return nodeset;
		}
	}
}