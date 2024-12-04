# watchtower

## Notes
- I use it to update all my containers automatically although this is not what it should be done in a production environment. There is a way just to let you know when there is an update and then, after you read the changelog, you can update it. Because this is a lab and I love fixing things from time to time, I have it this way.
- The env var ``WATCHTOWER_SCHEDULE`` is setup to each sunday at 12 pm.
- The env var ``WATCHTOWER_NOTIFICATION_URL`` is a webhook to a ``telegram channel`` so whenever an update is ready, you recieve a message.
- As you can see I have watchtower running individually on each lxc. If I had a single `VM`, I could just have one. 
