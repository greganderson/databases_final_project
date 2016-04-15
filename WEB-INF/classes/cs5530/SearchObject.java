package cs5530;

import java.util.Set;
import java.util.TreeSet;

public class SearchObject {
	public String sqlStart = "select p.* from POI p where p.name = p.name";
	public String sqlEnd = " group by p.pid";
	public String sqlParams = "";
	
	public SearchObject(String listOfNames, String priceRange, String address, String keywordList, String category) {
		// Add name
		if (!listOfNames.isEmpty()) {
			String[] names = listOfNames.split(" ");
			for (String name : names) {
				sqlParams += " and p.name like '%" + name + "%'";
			}
		}

		// Add price range
		if (!priceRange.isEmpty()) {
			String lowerStr = priceRange.substring(priceRange.indexOf("$") + 1);
			int lower = Integer.parseInt(lowerStr.substring(0, lowerStr.indexOf(" ")));
			int higher;
			if (lowerStr.contains("$"))
				higher = Integer.parseInt(lowerStr.substring(lowerStr.indexOf("$") + 1));
			else
				higher = Integer.MAX_VALUE;
			sqlParams += " and p.price_per_person >= " + lower + " and p.price_per_person <= " + higher;
		}

		// Add address
		if (!address.isEmpty()) {
			String[] words = address.split(" ");
			sqlParams += " and p.address like '";
			for (String word : words)
				sqlParams += "%" + word;
			sqlParams += "%'";
		}

		// Add keywords
		if (!keywordList.isEmpty()) {
			TreeSet<String> keywords = extractKeywords(keywordList);
			sqlParams += " and p.name in (select p1.name from Keywords k1, HasKeywords h1, POI p1" +
					" where k1.wid = h1.wid and h1.pid = p1.pid and (";
			for (String word : keywords)
				sqlParams += " k1.word like '%" + word + "%' or";
			sqlParams = sqlParams.substring(0, sqlParams.length()-3) + "))";
		}

		// Add category
		if (!category.isEmpty()) {
			sqlParams += " and p.category like '%" + category + "%'";
		}
	}

    private TreeSet<String> extractKeywords(String keywordsString) {
        keywordsString = keywordsString.replace(",", "");
        String[] keywordList = keywordsString.split(" ");
        TreeSet<String> keywords = new TreeSet<>();
        for (String word : keywordList)
            keywords.add(word.toLowerCase());
        return keywords;
    }
}
