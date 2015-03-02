$("#sale_store_id").empty()
  .append("<%= escape_javascript(render(:partial => @stores)) %>")

      <%= f.association :store do %>
        <%= f.grouped_collection_select :store_id, Channel.order(:channel), :stores, :channel, :id, :nama, include_blank: true %>
      <% end %>