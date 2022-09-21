# System

## Monitor Memory Allocation

```@docs
memuse
```

```@example
using Xfunc # hide
for i = 1:3
    a = zeros(1024, 1024, 5, 10);
    memuse()
end
```