Deface::Override.new :virtual_path      => 'issues/new',
                     :name              => 'replace_default_new_form',
                     :replace           => "erb[loud]:contains(\"render :partial => 'issues/form, :locals => {:f => f}'\")",
                     :partial           => 'issues/customized_form'

Deface::Override.new :virtual_path      => 'issues/_edit',
                     :name              => 'replace_default_form',
                     :replace           => "erb[loud]:contains(\"render :partial => 'form'\")",
                     :partial           => 'issues/customized_form'
