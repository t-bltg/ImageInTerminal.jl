struct TerminalGraphicDisplay{TC<:IO, TS<:IO} <: AbstractDisplay
    content_stream::TC
    summary_stream::TS
end
TerminalGraphicDisplay(io::IO) = TerminalGraphicDisplay(io, io)

Base.displayable(::TerminalGraphicDisplay, ::MIME"image/png") = true

function Base.display(d::TerminalGraphicDisplay, ::MIME"image/png", bytes::Vector{UInt8})
    # In this case, assume it to be png byte sequences, use FileIO
    # to find a decoder for it.
    img = FileIO.load(_format_stream(format"PNG", IOBuffer(bytes)))
    display(d, MIME("image/png"), img)
end

function Base.display(d::TerminalGraphicDisplay, ::MIME"image/png", img::AbstractArray{<:Colorant})
    println(d.summary_stream, summary(img), ":")
    ImageInTerminal.imshow(d.content_stream, img, colormode[1])
    return nothing
end

