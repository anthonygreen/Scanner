+++++++++++++++++++++++++++++++++++
READ_ME Details
+++++++++++++++++++++++++++++++++++

Author : William Daly
E-mail : William.Daly@bbc.co.uk
Date   : 19/12/2016

+++++++++++++++++++++++++++++++++++
What Is This File?
+++++++++++++++++++++++++++++++++++

This is a simple READ_ME text file to quickly understand and run the BBC Daly Scanner

+++++++++++++++++++++++++++++++++++
What Is The BBC Daly Scanner?
+++++++++++++++++++++++++++++++++++

The BBC Daly Scanner is a Ruby script that scans for video + audio content on the BBC website
It then takes the data of that content and prints it onto a single, clean and human-readable HTML page
This removes the need to go to various catalogue pages "TREVOR" and "IBL" and read individual video + audio JSON entries

+++++++++++++++++++++++++++++++++++
What Should I Have?
+++++++++++++++++++++++++++++++++++

Once you've downloaded the folder the contents should look a little like

	dalyw01$ ls
	BBC.rb			bbc_site_summary.css	get_bbc_site_info.rb
	READ_ME.txt		images

With the following images in the "images" directory

	dalyw01$ ls
	bbc_logo.jpeg		iplayer_icon.jpeg	news_icon.jpeg

+++++++++++++++++++++++++++++++++++
How Do I Get Started?
+++++++++++++++++++++++++++++++++++

Simply run the following command from the downloaded directory

	ruby get_bbc_site_info.rb

The script can take a while to execute (10 seconds appx) depending on your internet speed, so please be patient!

+++++++++++++++++++++++++++++++++++
What Should Happen When It's Done?
+++++++++++++++++++++++++++++++++++

The following file should get created once the script has finished

	daly_bbc_scanner.html

Your directory should now look a little like

	dalyw01$ ls
	BBC.rb			bbc_site_summary.css	get_bbc_site_info.rb
	READ_ME.txt		daly_bbc_scanner.html	images

+++++++++++++++++++++++++++++++++++
How Do I View The Results?
+++++++++++++++++++++++++++++++++++

You should be able to view the results on the freshly created HTML page on your browser "daly_bbc_scanner.html"
The accompanying CSS and image files help make the data more presentable!

















