These are a few helper classes, some based around commons IO found on java,
that subclass `NSInputStream`.

`HSCountingInputStream` counts all the bytes passed through it, useful for testing.
`HSRandomDataInputStream` provides random data as long as it is asked.
`HSRandomDataLengthInputStream` behaves a bit better than `HSRandomDataInputStream`
as it gets a length and provides data until reaches length.
`HSNSStringInputStream` provides an input stream from a NSString.

These are all based on the work done by [bjhomer](https://github.com/bjhomer),
on sublcassing an `NSInputStream`, and `HSRandomDataInputStream` was made by him.
You can check his [blog post](http://bjhomer.blogspot.com/2011/04/subclassing-nsinputstream.html) 
for more details.