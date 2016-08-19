partial = "<%=j render :partial => 'form_wrapper', :format => :html, :locals => { :state => @order.state, :order => @order } %>"
step = ($ '#checkout_<%= @order.state %>')
error = "<%= flash[:error] %>"

replaceCheckoutStep(step, partial, error)
