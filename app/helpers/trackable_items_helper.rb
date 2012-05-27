module TrackableItemsHelper
  # wrapped in a div to allow for styling the form to be inline
  def button_to_place_in_shelf_location(trackable_item, additional = false)
    # whether we should redirect to site basket or not
    # if no repositories are associated with this basket, specify site

    options = { :trackable_item => { :id => trackable_item.id,
        :type => trackable_item.class.name } }

    options[:urlified_name] = @site_basket.urlified_name if @current_basket.repositories.count < 1

    button_text = if additional
                    button_text = t('trackable_items_helper.add_to_additional_shelf_location')
                  else
                    button_text = t('trackable_items_helper.add_to_shelf_location')
                  end
    "<div class=\"add-to-shelf-location\">" +
      button_to(button_text,
                new_trackable_item_shelf_location_url(options)) +
      "</div>"
  end

  def shelf_locations_or_appropriate_action(trackable_item)
    html = String.new

    additional = false
    if trackable_item.has_shelf_locations?
      additional = true

      html += '<ul class="shelf-locations">'
      shelf_locations_count = 1
      trackable_item.shelf_locations.each do |shelf_location|
        html += '<li'
        html += ' class="first"'if shelf_locations_count == 1
        html += '>'

        html += link_to(shelf_location.code, repository_shelf_location_url(:repository_id => shelf_location.repository_id, :id => shelf_location))
        html += '</li>'
        shelf_locations_count += 1
      end

      html += '</ul>'
    end

    html += button_to_place_in_shelf_location(trackable_item, additional)

    html
  end

end
