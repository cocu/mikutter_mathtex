# -*- coding: utf-8 -*-
require "net/http"
require "cgi"

Plugin.create(:mathtex) do

    command(:mathtex,
            name: 'TeXの数式をアップロードする',
            condition: lambda{|opt| true},
            visuble: true,
            role: :postbox) do |opt|
        begin
            formula = nil
            url = "http://chart.apis.google.com/chart?cht=tx&chl="

            dialog = Gtk::Dialog.new
            entry = Gtk::Entry.new
            image = Gtk::Image.new
            dialog.add_buttons(["OK",Gtk::Dialog::RESPONSE_OK],
                               ["preview",Gtk::Dialog::RESPONSE_APPLY])
            dialog.vbox.pack_start(entry)
            dialog.vbox.pack_start(image)
            dialog.signal_connect("response") do |widget,response|
                case response
                when Gtk::Dialog::RESPONSE_OK
                    formula = ' ' + url + CGI.escape(entry.text)
                    p formula
                    Plugin.create(:gtk).widgetof(opt.widget).widget_post.buffer.text += formula
                    dialog.destroy
                when Gtk::Dialog::RESPONSE_APPLY
                    chl = CGI.escape(entry.text)
                    p chl
                    image.pixbuf = Gdk::WebImageLoader.pixbuf(url+chl,500,500){|pixbuf|
                        image.pixbuf=pixbuf
                    }
                end
            end
            dialog.show_all

        end
    end
end
