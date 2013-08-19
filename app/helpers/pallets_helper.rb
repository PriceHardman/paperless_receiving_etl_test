module PalletsHelper
  def categorized_descriptions

    #create a hash of arrays of the categories and freight descriptions in table freight_descriptions.

    raw_description_categories = FreightDescription.select("DISTINCT(description_category)") #get objects
    description_categories = raw_description_categories.inject([]) do |collection,element| #get description strings
      collection << element.description_category
    end
    results = {} #intialize raw hash.
    description_categories.each do |category|
      results[category] = FreightDescription.where(:description_category => category).inject([]) do |collection,element|
        collection << element.freight_description
      end
    end

    return results
  end
end