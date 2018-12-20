Deface::Override.new :virtual_path      => 'issues/new',
                     :name              => 'replace_default_form',
                     :replace           => "erb[loud]:contains('issues/form')",
                     :partial           => 'issues/customized_form'

Deface::Override.new :virtual_path      => 'issues/_edit',
                     :name              => 'replace_default_form',
                     :replace           => "erb[loud]:contains(\"render :partial => 'form'\")",
                     :partial           => 'issues/customized_form'
