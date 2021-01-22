package main

import (
	"testing"
)

func TestUsefulFeature(t *testing.T) {
	greet := UsefulFeature("dude")
	if greet != "Hello dude" {
		t.Errorf("Not cool")
	}
}
