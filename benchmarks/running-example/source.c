#include <stdlib.h>
#include <stdio.h>

struct node_t
{
    int data;
    struct node_t *next;
};

struct node_t *new()
{
    struct node_t *n = malloc(sizeof(struct node_t));
    n->next = NULL;
    return n;
}

void push(struct node_t *list, int x)
{
    struct node_t *n = malloc(sizeof(struct node_t));
    n->data = x;
    n->next = list->next;
    list->next = n;
}

void replace(int *dst, int x)
{
    *dst = x;
}

void replace_first(struct node_t *list, int x)
{
    replace(&list->next->data, x);
}

int first(struct node_t *list)
{
    return list->next->data;
}

int main()
{
    struct node_t *list = new();
    push(list, 1);
    struct node_t *sublist = list->next;
    push(sublist, 2);
    replace_first(list, 3);
    replace_first(sublist, 4);
}
