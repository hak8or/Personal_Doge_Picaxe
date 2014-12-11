Dogecoin p2p local node for mining
==================================

Sets up a Dogecoin p2p node running in a vm on your computer. You don't need to mess with linux, dual boot, dependencies, or the command line (much). What is a p2p pool you ask? [Bam] (http://whatisp2pool.com/)!

Why would you want to do this?
- You don't have to worry about ping! It is running locally so your ping is negligible.
- Since your DOA rate will be below P2P pools DOA rate, you can use other miners rejects!
- No fee's! All mining proceeds go to you, and you alone.
- It will remain up while your computer is up. Don't need to worry about fail over or anything.
- It is only your miners, so if someone comes in with a massive mining operation, the nodes difficulty won't go ballistic and cause your DOA's to rise (assuming you didn't set share difficulty manually).

Why would you want to use P2P pool in the first place?
- P2P pool cannot be used for a 51% attack.
- P2P pool is very scalable, it can easily handle the entire dogecoin hash rate.
- There is no owner! Not only does this prevent the pool being used for a 51% attack, it also means no one can steal your coins!
- You also get in on transaction fee's! (?)
- [This] (http://www.reddit.com/r/dogemining/comments/1uncvb/the_benefits_of_mining_using_p2pool_better) Reddit post gives more benefits and discussion.


##### This is still in Alpha!
 Expect bugs and various issues. It works fine on my end, but not all edge cases are taken into consideration so various problems may show up. Send me an email or make an issue and I will get on it as soon as I can. This is NOT production ready.


So, how do you get started? Easy!
---------------------------------
1) Download and install:
- [VirtualBox] (https://www.virtualbox.org/)
- [Vagrant] (http://www.vagrantup.com/)
- [Git GUI for windows] (http://windows.github.com/) or any other Git client
 
2) Run the following commands
```Batchfile
git clone git://github.com/hak8or/Personal_Doge_Picaxe.git
cd Personal_Doge_Picaxe
vagrant up # Now we wait ...
```
3) Wait for the dogecoin client to download the blockchain, which can take a few solid hours. Go browse /r/dogecoin in the meantime!

4) Once the dogecoin client is done downloading the blockchain, you can point your miners to your new local node by using ```localhost:22550```

You can view the nodes status as well as your mining results at ```localhost:22550``` and the pools output with the ```screen -x myp2pool``` command.

If you restarted the vagrant box, then just restart! Everything gets automatically run again via a cronjob behind the scenes.


Troubleshooting
---------------
##### *Confused shibe here!* What do I put in my mining program's command line? 
I use [sgminer] (https://github.com/veox/sgminer) instead of cgminer since it is now actively developed for GPU mining unlike CGMiner's creator who does not wish to support alt-coins. The address is the foundation's general donation fund, so feel free to use it while testing.
``` sgminer -o stratum+tcp://localhost:22550 -u DJ7zB7c5BsB9UJLy1rKQtY7c6CQfGiaRLM -p x -I 20 ```


##### I have been mining for over 12 hours and nothing!
P2P pool works based on [PPLNS] (https://litecoin.info/Mining_pool_comparison#Reward_types), which is designed to combat pool hoppers. One side effect is that your first payout will be a while, from 3 to 24 hours. If you get nothing after 24 hours, then best to do some googling or looking around on /r/dogecoinmining for help. You can also use the fantastic [sharecalc] (http://www.nckpnny.com/sharecalc/) tool for getting an estimate of your first payout.


##### How should I get to the moon if my payouts are so low!?
P2P pool is as of January 30th about only 1.53 Ghash/s, a far cry from the total network hash rate of about 90 Ghash/s. This means that the pool will find blocks more rarely. Also, you might have too low of a hash rate to even get on the payout list, so it is recommended for you to have at least 300 Khash/s. While payouts are sporadic, over time they will even out.


##### Ok, my rejects are much better but still not ideal, what can I do?
This should only be happening if you are running multiple different cards on the node. Try to decrease the share difficulty (the +somenumber) value on the slower card with more rejects.


##### What is up with all the litecoin things? 
You can safely ignore that, I haven't swapped out the litecoin assets for dogecoin yet.


##### My HW error rate is insainly high!
This is normal, the node is setting up the difficulty for the first time. Let your miners run for maybe a minute or two and then restart them, everything should be fine.


Make sure to check the [wiki] (https://github.com/hak8or/Personal_Doge_Picaxe/wiki) for other questions and possible solutions not found here!


Worthy links
------------
- http://foundation.dogecoin.com/
- http://www.nckpnny.com/sharecalc/
- http://dogechain.info/chain/Dogecoin
- http://doges.org/index.php/topic,5586.0.html



