<h1 align="center">Magic Links Example for Phoenix</h1>

<p align="center">
    <a href="https://github.com/sevensidedmarble/phoenix-magic-links/commit/dd53d7979e1a094562c7b6a699b11b0ed5cc85e1">Click here for a link to the most useful commit</a>
</p>

<br />

This repo is a reference for setting up a comprehensive Magic Link solution in Phoenix, based off of Phoenix's
`phx.gen.auth` generator. This reference will be useful for you, assuming that:

1. You have started a new Phoenix project, or have an existing one.
2. You have ran the `phx.gen.auth` generator (this project assumes you ran `mix phx.gen.auth Users User users`, but you
   can adjust the context or schemas accordingly).
3. You want to add sign-in with magic links.
4. You do not want any password handling code left over. Your app will only use emails (but maybe you want to add social
   auth or something, but not passwords).

The best way to use this as a reference would be to just refer to [this commit](https://github.com/sevensidedmarble/phoenix-magic-links/commit/dd53d7979e1a094562c7b6a699b11b0ed5cc85e1). This has all the changes you need to
implement in your own project. You can refer back to this commit as a starting point in new projects.

This work is an extension of [this post](https://johnelmlabs.com/posts/magic-link-auth). I like what [@JohnElmLabs](https://twitter.com/JohnElmLabs) showed off in this post, but I wanted to extend it and show the result, in particular showing what you can remove from the authentication generator.
