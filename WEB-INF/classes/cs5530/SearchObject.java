package cs5530;

import java.util.Set;
import java.util.TreeSet;

public class SearchObject {
	public String sqlStart = "select p.* from POI p where p.name = p.name";
	public String sqlEnd = " group by p.pid";
	public String sqlParams = "";
	public String trustedParams = " and f.username in (select username2 from Trust t group by username2 having avg(is_trusted) > 0)";
	public String sqlStartScore = "select p.*, avg(f.score) as score from POI p, Feedback f where p.pid = f.pid";
	public boolean includeScore = false;
	public boolean includeTrustedParams = false;

	public String sql;
	
	public SearchObject(String nameString, String priceRange, String address, String keywordList, String category, String ordering, boolean includeScore, boolean includeTrustedParams) {
		// Add name
		if (nameString != null && !nameString.isEmpty()) {
			String[] names = nameString.split(" ");
			for (String name : names) {
				sqlParams += " and p.name like '%" + name + "%'";
			}
		}

		// Add price range
		if (priceRange != null && !priceRange.isEmpty()) {
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
		if (address != null && !address.isEmpty()) {
			String[] words = address.split(" ");
			sqlParams += " and p.address like '";
			for (String word : words)
				sqlParams += "%" + word;
			sqlParams += "%'";
		}

		// Add keywords
		if (keywordList != null && !keywordList.isEmpty()) {
			TreeSet<String> keywords = extractKeywords(keywordList);
			sqlParams += " and p.name in (select p1.name from Keywords k1, HasKeywords h1, POI p1" +
					" where k1.wid = h1.wid and h1.pid = p1.pid and (";
			for (String word : keywords)
				sqlParams += " k1.word like '%" + word + "%' or";
			sqlParams = sqlParams.substring(0, sqlParams.length()-3) + "))";
		}

		// Add category
		if (category != null && !category.isEmpty()) {
			sqlParams += " and p.category like '%" + category + "%'";
		}

		this.includeScore = includeScore;
		this.includeTrustedParams = includeTrustedParams;
		setSql(ordering);
	}

	private void setSql(String ordering) {
		String start = includeScore ? sqlStartScore : sqlStart;
		String extraParams = includeTrustedParams ? trustedParams : "";
        sql = start + sqlParams + extraParams + sqlEnd + ordering;
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
