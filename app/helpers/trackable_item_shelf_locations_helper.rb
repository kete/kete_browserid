module TrackableItemShelfLocationsHelper
  def javascript_repository_id_observer_and_adjust_code_autocomplete(urlified_name)
      javascript_tag("jQuery(document).ready(function(){
      jQuery(\"#trackable_item_shelf_location_repository_id\").change(
        function() {
          jQuery(\"#trackable_item_shelf_location_code\").val('');
          
          var repository_id = jQuery(\"#trackable_item_shelf_location_repository_id\").val();
          var new_shelf_locations_url = \"/#{urlified_name}/repositories/\" + repository_id + \"/shelf_locations.json\";
          
          trackable_item_shelf_location_code_auto_completer.url = new_shelf_locations_url;

        });

      });")
  end
end
