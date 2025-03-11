<script>
    import NUI from './NUI.vue';
    import Button from './Button.vue';
    import Label from './Label.vue';
    export default {
        name: 'MyGroup',
        components: {
            NUI,
            Button,
            Label
        },
        props: {},
        data() { 
            return {
                Members: [],
            }
        },
        methods: {
            GetMembers: async function() {
                const members = await NUI.methods.Callback("RequestMembers")
                if (!members) { return }
                this.Members = members
            },
            Kick: function(id) {
                NUI.methods.Callback("Kick", { id: id })
                this.GetMembers()
            },
        },
        mounted() {
            this.GetMembers()
        },
    };
</script>

<template>
    <div class="members-container">
        <h2>My Group</h2>
        <div class="members-list">
            <div class="members-item" v-for="member in this.Members">
                <div class="label">
                    <div class="members-item-name"> {{ member.name }}</div>
                    <Label class="owner" v-show="member.groupOwner" text="Owner" icon="fas fa-crown"/>
                </div>
            
                <Button v-show="!member.groupOwner" class="kick" icon="fa-solid fa-user-slash" toolTip="Kick" @click="Kick(member.id)"/>
            </div>
        </div>
    </div>
</template>

<style scoped>
    .members-container {
        display: flex;
        flex-direction: column;
        gap: 1vh;
    }

    .members-list {
        display: flex;
        flex-direction: column;
        gap: 1vh;
    }

    .members-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.6vh 0.4vh;
        border-radius: 0.8vh;
        background-color: var(--secondaryDarkColor);
    }

    .label {
        display: flex;
        align-items: center;
        gap: 0.6vh;
    }

    .owner {
        background-color: #ffaa006b;
    }

    .members-item-name {
        color: white;
    }

    .kick {
        background-color: #ff6b6b60;
    }

    .kick:hover {
        background-color: rgba(255, 107, 107, 0.493);
    }
</style>