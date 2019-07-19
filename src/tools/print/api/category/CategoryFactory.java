package tools.print.api.category;

import tools.print.api.category.Category;
import tools.print.api.category.ObjectFactory;

public class CategoryFactory {
	public static Category CategoryCreateList(ObjectFactory factory, int id, String Name, String description, String code, String value1, String value2, int infoId) {
		Category category = factory.createCategory();
		category.setId(id);
		category.setCategoryName(Name);
		category.setDescription(description);
		category.setCategoryCode(code);
		category.setCategoryValue1(value1);
		category.setCategoryValue2(value2);
		category.setCategoryInfoid(infoId);
		
		return category;
	}

}
